import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/component.dart';
import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/widgets/add_known_problem_dialog.dart';
import 'package:doctor_mfc_admin/widgets/base_input.dart';
import 'package:doctor_mfc_admin/widgets/custom_alert_dialog.dart';
import 'package:doctor_mfc_admin/widgets/object_elevated_button.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader_with_add_button.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddComponentDialog extends StatefulWidget {
  final String systemName;
  final Component? component;

  final Function(Component) callback;

  const AddComponentDialog({
    required this.systemName,
    required this.callback,
    this.component,
    Key? key,
  }) : super(key: key);

  @override
  State<AddComponentDialog> createState() => _AddComponentDialogState();
}

class _AddComponentDialogState extends State<AddComponentDialog> {
  final descriptionController = TextEditingController();

  bool get descriptionIsNotEmpty => descriptionController.text.isNotEmpty;
  String get description => descriptionController.text;

  late List<Problem> problems = [];

  bool get isUpdatingComponent => widget.component != null;

  @override
  void initState() {
    if (isUpdatingComponent) {
      Component component = widget.component!;
      descriptionController.text = component.description;
      problems = component.problems;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addListeners();

    return CustomAlertDialog(
      title: 'Add new component',
      subtitle: '${widget.systemName}',
      showBackButton: false,
      body: [
        BaseInput(title: 'Component name', controller: descriptionController),
        SizedBox(height: kDefaultPadding),
        SectionSubheaderWithAddButton(
          title: 'Known problems',
          onPressed: (descriptionIsNotEmpty)
              ? () => navigateToProblemCreation()
              : null,
          addButtonText: 'Add known problem',
        ),
        SizedBox(height: kDefaultPadding / 2),
        SizedBox(
          height: 250,
          width: 300,
          child: ListView.separated(
            itemCount: problems.length,
            itemBuilder: (context, i) => ObjectElevatedButton(
              title: '${problems[i].description}',
              onPressed: () =>
                  navigateToProblemUpdate(problem: problems[i], index: i),
            ),
            separatorBuilder: (context, i) =>
                SizedBox(height: kDefaultPadding / 2),
          ),
        ),
      ],
      finishButtonTitle:
          isUpdatingComponent ? 'Update component' : 'Add component',
      isButtonEnabled: descriptionIsNotEmpty,
      onFinish: () => onFinish(),
    );
  }

  void navigateToProblemCreation() {
    Navigator.push(
      context,
      DialogRoute(
        context: context,
        builder: (context) => AddKnownProblemDialog(
          subtitle: description,
          callback: (newProblem) => createProblem(newProblem),
        ),
        barrierColor: Colors.transparent,
      ),
    );
  }

  void navigateToProblemUpdate({required Problem problem, required int index}) {
    Navigator.push(
      context,
      DialogRoute(
        context: context,
        builder: (context) => AddKnownProblemDialog(
          subtitle: description,
          callback: (newProblem) =>
              updateProblem(problem: newProblem, index: index),
          problem: problem,
        ),
        barrierColor: Colors.transparent,
      ),
    );
  }

  void updateProblem({required Problem problem, required int index}) {
    problems[index] = problem;
    setState(() {});
  }

  void createProblem(Problem problem) {
    problems.add(problem);
    setState(() {});
  }

  void onFinish() {
    widget.callback(
      Component(
        id: Uuid().v4(),
        description: description,
        problems: problems,
      ),
    );

    Navigator.pop(context);
  }

  void addListeners() {
    descriptionController.addListener(() => setState(() {}));
  }
}
