import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/component.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/services/database.dart';

import 'package:doctor_mfc_admin/src/component_details_page.dart';
import 'package:doctor_mfc_admin/widgets/body_template.dart';
import 'package:doctor_mfc_admin/widgets/component_dialog.dart';
import 'package:doctor_mfc_admin/widgets/custom_card.dart';
import 'package:doctor_mfc_admin/widgets/custom_loading_indicator.dart';
import 'package:doctor_mfc_admin/widgets/future_loading_indicator.dart';
import 'package:doctor_mfc_admin/widgets/green_elevated_button.dart';

import 'package:doctor_mfc_admin/widgets/section_subheader.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader_with_add_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SystemDetailsPage extends StatefulWidget {
  final System system;

  SystemDetailsPage(
    this.system, {
    Key? key,
  }) : super(key: key);

  @override
  _SystemDetailsPageState createState() => _SystemDetailsPageState();
}

class _SystemDetailsPageState extends State<SystemDetailsPage> {
  late System system = widget.system;

  final modelController = TextEditingController();
  final brandController = TextEditingController();
  final typeController = TextEditingController();

  String get brand => brandController.text;
  String get model => modelController.text;
  String get type => typeController.text;

  late bool editingEnabled = false;
  late bool manageModeEnabled = false;

  @override
  void initState() {
    modelController.text = system.description;
    brandController.text = system.brand;
    typeController.text = system.type;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<System>>(
        stream: Database().getSystemSnapshotById(system.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.data() != null) {
              system = snapshot.data!.data()!;

              return BodyTemplate(
                title: '${system.description}',
                body: [
                  Row(
                    children: [
                      SectionSubheader('System information'),
                      SizedBox(width: kDefaultPadding / 2),
                      (editingEnabled)
                          ? Container()
                          : TextButton(
                              onPressed: () => toggleEditMode(),
                              child: Text('Edit',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.copyWith(color: Colors.grey)))
                    ],
                  ),
                  SizedBox(height: kDefaultPadding),
                  attributeInputs(),
                  SizedBox(height: kDefaultPadding / 2),
                  confirmEditButton(),
                  SizedBox(height: kDefaultPadding * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SectionSubheaderWithAddButton(
                        title: 'Components',
                        addButtonText: 'Add component',
                        onPressed:
                            (manageModeEnabled) ? null : () => onAddPressed(),
                      ),
                      TextButton(
                        onPressed: () => toggleManageMode(),
                        child: Text((!manageModeEnabled) ? 'Manage' : 'Finish'),
                        style: TextButton.styleFrom(
                          primary: kFontBlack.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: kDefaultPadding),
                  componentsList()
                ],
              );
            } else
              return Container();
          } else
            return CustomLoadingIndicator();
        });
  }

  Row attributeInputs() {
    return Row(
      children: [
        attributeTextField(
          title: 'Model',
          controller: modelController,
        ),
        SizedBox(width: kDefaultPadding),
        attributeTextField(
          title: 'Brand',
          controller: brandController,
        ),
        SizedBox(width: kDefaultPadding),
        attributeTextField(
          title: 'Type',
          controller: typeController,
          enableEdit: false,
        ),
      ],
    );
  }

  Widget componentsList() {
    if (system.components.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        itemCount: system.components.length,
        itemBuilder: (context, i) {
          Component component = system.components[i];

          return Align(
            alignment: Alignment.centerLeft,
            child: CustomCard(
              title: component.description,
              body: [
                Text('${component.problems.length} known problems'),
                SizedBox(height: kDefaultPadding / 4),
                Text('${component.solutions.length} solutions'),
              ],
              onPressed: () =>
                  goToComponentDetails(component, system.description),
              showDeleteButton: manageModeEnabled,
              onDelete: () => promptComponentDelete(component),
            ),
          );
        },
        separatorBuilder: (context, i) {
          return SizedBox(height: kDefaultPadding / 2);
        },
      );
    } else
      return Text('None', style: TextStyle(color: Colors.grey));
  }

  Widget attributeTextField({
    required String title,
    required TextEditingController controller,
    bool? enableEdit,
  }) {
    return Flexible(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: kDefaultPadding / 3),
            TextField(
              controller: controller,
              enabled: enableEdit ?? editingEnabled,
              decoration: InputDecoration(
                fillColor: Colors.grey[300],
                filled: (enableEdit != null) ? !enableEdit : !editingEnabled,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget confirmEditButton() {
    if (editingEnabled) {
      return Row(
        children: [
          TextButton(
            child: Text('Delete'),
            style: TextButton.styleFrom(primary: kAccentColor),
            onPressed: () => promptDelete(),
          ),
          Spacer(),
          ElevatedButton(
            child: Text('Cancel'),
            onPressed: () => cancelChanges(),
          ),
          SizedBox(width: kDefaultPadding),
          ElevatedButton(
            child: Text('Update'),
            onPressed: () {
              updateSystem();
              toggleEditMode();
            },
          ),
        ],
      );
    } else
      return Container();
  }

  void updateSystem() async {
    system.brand = brand;
    system.description = model;

    await futureLoadingIndicator(context, Database().updateSystem(system));

    setState(() {});
  }

  void toggleEditMode() {
    setState(() {
      editingEnabled = !editingEnabled;
    });
  }

  void cancelChanges() {
    setState(() {
      modelController.text = system.description;
      brandController.text = system.brand;
      typeController.text = system.type;
      editingEnabled = false;
    });
  }

  goToComponentDetails(Component component, String model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ComponentDetailsPage(
          system: system,
          component: component,
        ),
      ),
    );
  }

  promptDelete() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${system.description}'),
            content: Text(
              """Are you sure you want to delete this system? 
                You can't revert this action.""",
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding: EdgeInsets.all(kDefaultPadding),
            actions: [
              TextButton(
                child: Text('Delete'),
                style: TextButton.styleFrom(primary: kAccentColor),
                onPressed: () {
                  // TODO: Delete system.
                  futureLoadingIndicator(
                    context,
                    Database().deleteSystem(system.id),
                  )
                      .then((value) => Navigator.pop(context))
                      .whenComplete(() => Navigator.pop(context));
                },
              ),
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  void onAddPressed() => showDialog(
        context: context,
        builder: (context) => ComponentDialog(
          systemName: model,
          callback: (component) => addComponent(component),
        ),
      );

  void addComponent(Component component) {
    system.addComponent(component);

    futureLoadingIndicator(context, Database().updateSystem(system));
  }

  void toggleManageMode() {
    cancelChanges();
    setState(() {
      manageModeEnabled = !manageModeEnabled;
    });
  }

  void onDelete(Component component) {
    system.deleteComponent(component);

    futureLoadingIndicator(context, Database().updateSystem(system))
        .then((value) => Navigator.pop(context));
  }

  void promptComponentDelete(Component component) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${component.description}'),
          content: Text('Are you sure you want to delete this component?'),
          buttonPadding: EdgeInsets.all(kDefaultPadding),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => onDelete(component),
              child: Text('Delete'),
              style: TextButton.styleFrom(primary: kAccentColor),
            ),
            GreenElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
