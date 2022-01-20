import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/problem.dart';

import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/services/database.dart';
import 'package:doctor_mfc_admin/src/problem_page.dart';

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

  List<Problem> problems = [];

  // Getters
  String get systemModel => modelController.text;

  @override
  Widget build(BuildContext context) {
    addListeners();

    return Scaffold(
      body: BodyTemplate(
        title: 'Add new system',
        body: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              attributeInputs(),
              SizedBox(height: kDefaultPadding),
              problemsList(),
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
                  Database().addSystems([
                    System(
                      id: Uuid().v4(),
                      description: modelController.text,
                      brand: brandController.text,
                      type: typeController.text,
                      problems: problems,
                    ),
                  ]),
                ).then(
                  (_) => onComplete(),
                  onError: (err, stack) => onError(err, stack),
                )
            : null,
      ),
    );
  }

  Widget problemsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionSubheaderWithButton(
          title: 'Problems',
          onPressed: () => navigateToProblemAdd(),
          buttonText: 'Add problem',
        ),
        SizedBox(height: kDefaultPadding / 2),
        ListView.separated(
          shrinkWrap: true,
          itemCount: problems.length,
          itemBuilder: (context, i) => ObjectElevatedButton(
            title: '${problems[i].description}',
            onPressed: () => navigateToProblemUpdate(
              problem: problems[i],
              index: i,
            ),
          ),
          separatorBuilder: (context, i) =>
              SizedBox(height: kDefaultPadding / 2),
        )
      ],
    );
  }

  Widget attributeInputs() {
    return Container(
      child: Row(
        children: [
          attributeInput(title: 'Model', controller: modelController),
          SizedBox(width: kDefaultPadding),
          attributeInput(title: 'Brand', controller: brandController),
          SizedBox(width: kDefaultPadding),
          attributeInput(title: 'Type', controller: typeController),
        ],
      ),
    );
  }

  Widget attributeInput(
      {required String title, required TextEditingController controller}) {
    return Expanded(
      child: BaseInput(
        title: title,
        controller: controller,
        // width: 300,
      ),
    );
  }

  void navigateToProblemAdd() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProblemPage(
            subtitle: '$systemModel',
            callback: (problem) => addProblem(problem),
          ),
        ),
      );

  void navigateToProblemUpdate({
    required Problem problem,
    required int index,
  }) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProblemPage(
            problem: problem,
            callback: (updatedProblem) =>
                updateProblem(problem: updatedProblem, index: index),
            subtitle: '$systemModel',
          ),
        ),
      );

  void addProblem(Problem problem) {
    problems.add(problem);
    setState(() {});
  }

  void updateProblem({required Problem problem, required int index}) {
    problems[index] = problem;
    setState(() {});
  }

  void cleanEntries() {
    typeController.clear();
    modelController.clear();
    brandController.clear();

    problems = [];
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
