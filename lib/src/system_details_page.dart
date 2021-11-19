import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/component.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/services/database.dart';

import 'package:doctor_mfc_admin/services/test/test_systems_service.dart';
import 'package:doctor_mfc_admin/widgets/body_template.dart';
import 'package:doctor_mfc_admin/widgets/custom_card.dart';
import 'package:doctor_mfc_admin/widgets/future_loading_indicator.dart';

import 'package:doctor_mfc_admin/widgets/section_subheader.dart';
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
  final modelController = TextEditingController();
  final brandController = TextEditingController();
  final typeController = TextEditingController();

  bool editingEnabled = false;

  @override
  void initState() {
    modelController.text = widget.system.model;
    brandController.text = widget.system.brand;
    typeController.text = widget.system.type;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final System system = widget.system;

    return BodyTemplate(
      title: '${system.model}',
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
        SectionSubheader('Components'),
        SizedBox(height: kDefaultPadding),
        componentsList()
      ],
    );
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

  StatelessWidget componentsList() {
    if (widget.system.components != null) {
      List<Component> components = widget.system.components!;

      return ListView.separated(
        shrinkWrap: true,
        itemCount: components.length,
        itemBuilder: (context, i) {
          Component component = components[i];

          return Align(
            alignment: Alignment.centerLeft,
            child: CustomCard(
              title: component.description,
              body: [],
              onPressed: () {},
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
          ElevatedButton(
            child: Text('Cancel'),
            onPressed: () {
              cancelChanges();
              toggleEditMode();
            },
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

  void updateSystem() {
    futureLoadingIndicator(
        context,
        Database().updateSystem(
          id: widget.system.id,
          brand: brandController.text,
          model: modelController.text,
          type: typeController.text,
        ));
  }

  void toggleEditMode() {
    setState(() {
      editingEnabled = !editingEnabled;
    });
  }

  void cancelChanges() {
    modelController.text = widget.system.model;
    brandController.text = widget.system.brand;
    typeController.text = widget.system.type;
  }
}
