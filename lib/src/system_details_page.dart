import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/problem.dart';

import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/services/database.dart';
import 'package:doctor_mfc_admin/src/problem_page.dart';

import 'package:doctor_mfc_admin/widgets/body_template.dart';

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
                  SectionSubheaderWithButton(
                    title: 'Problems',
                    buttonText: 'Add problem',
                    onPressed:
                        (manageModeEnabled) ? null : () => onAddPressed(),
                    enableManageButton: true,
                    onManageButtonPressed: () => toggleManageMode(),
                    manageModeEnabled: manageModeEnabled,
                  ),
                  SizedBox(height: kDefaultPadding),
                  problemsList()
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

  Widget problemsList() {
    if (system.problems.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        itemCount: system.problems.length,
        itemBuilder: (context, i) {
          Problem problem = system.problems[i];

          return Align(
            alignment: Alignment.centerLeft,
            child: CustomCard(
              title: problem.description,
              body: [
                Text('${problem.solutions.length} solutions'),
              ],
              onPressed: () => goToProblemDetails(problem, system.description),
              showDeleteButton: manageModeEnabled,
              onDelete: () => promptProblemDelete(problem),
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

  void updateSystem({Problem? problem, Problem? updatedProblem}) async {
    system.brand = brand;
    system.description = model;
    if (problem != null && updatedProblem != null) {
      system.problems[system.problems.indexOf(problem)] = updatedProblem;
    }
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

  goToProblemDetails(Problem problem, String model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProblemPage(
          callback: (updatedProblem) {
            updateSystem(problem: problem, updatedProblem: updatedProblem);
          },
          subtitle: '$model',
          problem: problem,
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

  void onAddPressed() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProblemPage(
            subtitle: model,
            callback: (problem) => addProblem(problem),
          ),
        ),
      );

  void addProblem(Problem problem) {
    system.problems.add(problem);

    futureLoadingIndicator(context, Database().updateSystem(system));
  }

  void toggleManageMode() {
    cancelChanges();
    setState(() {
      manageModeEnabled = !manageModeEnabled;
    });
  }

  void promptProblemDelete(Problem problem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete problem'),
          content: Text('Are you sure you want to delete this known problem?'),
          buttonPadding: EdgeInsets.all(kDefaultPadding),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => onDelete(problem),
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

  void onDelete(Problem problem) {
    system.deleteProblem(problem);

    futureLoadingIndicator(context, Database().updateSystem(system))
        .then((value) => Navigator.pop(context));
  }
}
