import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/component.dart';

import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/services/database.dart';

import 'package:doctor_mfc_admin/widgets/component_dialog.dart';
import 'package:doctor_mfc_admin/widgets/base_input.dart';

import 'package:doctor_mfc_admin/widgets/body_template.dart';

import 'package:doctor_mfc_admin/widgets/future_loading_indicator.dart';
import 'package:doctor_mfc_admin/widgets/object_elevated_button.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader_with_add_button.dart';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddSystemPage extends StatefulWidget {
  AddSystemPage({Key? key}) : super(key: key);

  @override
  _AddSystemPageState createState() => _AddSystemPageState();
}

class _AddSystemPageState extends State<AddSystemPage> {
  final modelController = TextEditingController();
  final brandController = TextEditingController();
  final typeController = TextEditingController();

  late List<Component> components = [];

  // Getters
  String get systemModel => modelController.text;

  @override
  Widget build(BuildContext context) {
    addListeners();

    return Scaffold(
      body: BodyTemplate(
        title: 'Add new system',
        body: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              attributeInputs(),
              Spacer(),
              componentsColumn(),
            ],
          ),
          SizedBox(height: kDefaultPadding * 3),
          createSystemButton(),
        ],
      ),
    );
  }

  Center createSystemButton() {
    return Center(
      child: ElevatedButton(
        child: Text('Create system'),
        onPressed: (canFinish())
            ? () => futureLoadingIndicator(
                  context,
                  Database().addSystem(
                    System(
                      id: Uuid().v4(),
                      model: modelController.text,
                      brand: brandController.text,
                      type: typeController.text,
                      components: components,
                    ),
                  ),
                ).then(
                  (_) => onComplete(),
                  onError: (err, stack) => onError(err, stack),
                )
            : null,
      ),
    );
  }

  Widget componentsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionSubheaderWithAddButton(
          title: 'Components',
          onPressed: () => openComponentCreationDialog(),
          addButtonText: 'Add component',
        ),
        SizedBox(height: kDefaultPadding / 2),
        SizedBox(
          height: 250,
          width: 300,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: components.length,
            itemBuilder: (context, i) => ObjectElevatedButton(
              title: '${components[i].description}',
              onPressed: () => openComponentUpdateDialog(
                component: components[i],
                index: i,
              ),
            ),
            separatorBuilder: (context, i) =>
                SizedBox(height: kDefaultPadding / 2),
          ),
        )
      ],
    );
  }

  Column attributeInputs() {
    return Column(
      children: [
        attributeInput(title: 'Model', controller: modelController),
        SizedBox(height: kDefaultPadding),
        attributeInput(title: 'Brand', controller: brandController),
        SizedBox(height: kDefaultPadding),
        attributeInput(title: 'Type', controller: typeController),
      ],
    );
  }

  Widget attributeInput(
      {required String title, required TextEditingController controller}) {
    return BaseInput(
      title: title,
      controller: controller,
      width: 300,
    );
  }

  void openComponentCreationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ComponentDialog(
          systemName: '$systemModel',
          callback: (newComponent) => createComponent(newComponent),
        );
      },
    );
  }

  void openComponentUpdateDialog(
      {required Component component, required int index}) {
    showDialog(
      context: context,
      builder: (context) {
        return ComponentDialog(
          systemName: '$systemModel',
          callback: (newComponent) =>
              updateComponent(component: newComponent, index: index),
          component: component,
        );
      },
    );
  }

  void createComponent(Component newComponent) {
    components.add(newComponent);
    setState(() {});
  }

  void updateComponent({required Component component, required int index}) {
    components[index] = component;
    setState(() {});
  }

  void cleanEntries() {
    typeController.clear();
    modelController.clear();
    brandController.clear();

    components = [];
  }

  void onComplete() {
    cleanEntries();

    final snackBar = SnackBar(content: Text('System created successfully!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {});
  }

  bool canFinish() {
    if (modelController.text.isNotEmpty &&
        brandController.text.isNotEmpty &&
        typeController.text.isNotEmpty) {
      return true;
    } else
      return false;
  }

  void addListeners() {
    modelController.addListener(() => setState(() {}));
    brandController.addListener(() => setState(() {}));
    typeController.addListener(() => setState(() {}));
  }

  onError([Object? error, StackTrace? stackTrace]) {
    print(error);
    print(stackTrace);

    final snackBar = SnackBar(content: Text('A problem ocurred. Try again.'));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // TODO: Make dropdown
  // Widget typeDropdown(
  //     {required String title, required TextEditingController controller}) {
  //   return Container(
  //     constraints: BoxConstraints(
  //       minWidth: 200,
  //       maxWidth: 300,
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text(
  //           '$title',
  //           style: Theme.of(context).textTheme.headline6,
  //         ),
  //         DropdownButton(
  //           items: items,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
