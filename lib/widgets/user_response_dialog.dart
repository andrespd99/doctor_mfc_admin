import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/models/user_response.dart';
import 'package:doctor_mfc_admin/widgets/solution_dialog.dart';
import 'package:doctor_mfc_admin/widgets/base_input.dart';
import 'package:doctor_mfc_admin/widgets/custom_alert_dialog.dart';
import 'package:doctor_mfc_admin/widgets/object_elevated_button.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader_with_add_button.dart';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UserResponseDialog extends StatefulWidget {
  final Function(UserResponse) callback;
  final UserResponse? userResponse;
  final String question;

  UserResponseDialog({
    required this.callback,
    required this.question,
    this.userResponse,
    Key? key,
  }) : super(key: key);

  @override
  _UserResponseDialogState createState() => _UserResponseDialogState();
}

class _UserResponseDialogState extends State<UserResponseDialog> {
  final descriptionController = TextEditingController();
  late bool isOkResponse = false;

  late List<Solution> solutions = [];

  /// Checks if an [UserResponse] has been given.
  bool get isUpdatingResponse => widget.userResponse != null;

  bool get canFinish => descriptionController.text.isNotEmpty;

  String get answerDescription => descriptionController.text;
  String get subtitle => '${widget.question} $answerDescription';

  @override
  void initState() {
    if (isUpdatingResponse) {
      UserResponse userResponse = widget.userResponse!;
      descriptionController.text = userResponse.description;
      isOkResponse = userResponse.isOkResponse;
      solutions = userResponse.solutions;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addListeners();

    return CustomAlertDialog(
      title: 'Add user response',
      subtitle: widget.question,
      body: [
        descriptionInput(),
        SizedBox(height: kDefaultPadding),
        isOkCheckbox(),
        SizedBox(height: kDefaultPadding),
        solutionsSection()
      ],
      finishButtonTitle: (isUpdatingResponse) ? 'Save' : 'Add response',
      onFinish: () => onFinish(),
      isButtonEnabled: canFinish,
    );
  }

  Column solutionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionSubheaderWithAddButton(
          title: 'Solutions',
          onPressed: !isOkResponse ? () => navigateToSolutionDialog() : null,
          addButtonText: 'Add solution',
        ),
        SizedBox(height: kDefaultPadding / 2),
        SizedBox(
          width: 250,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: solutions.length,
            itemBuilder: (context, i) => ObjectElevatedButton(
              title: '${solutions[i].description}',
              onPressed: () =>
                  navigateToExistingSolutionDialog(solutions[i], i),
            ),
            separatorBuilder: (context, i) =>
                SizedBox(height: kDefaultPadding / 2),
          ),
        ),
      ],
    );
  }

  Future<dynamic> navigateToSolutionDialog() {
    return Navigator.push(
      context,
      DialogRoute(
        context: context,
        builder: (context) => SolutionDialog(
          subtitle: subtitle,
          callback: (solution) => createSolution(solution),
        ),
        barrierColor: Colors.transparent,
      ),
    );
  }

  Future<dynamic> navigateToExistingSolutionDialog(
      Solution solution, int index) {
    return Navigator.push(
      context,
      DialogRoute(
        context: context,
        builder: (context) => SolutionDialog(
          subtitle: subtitle,
          callback: (solution) => updateSolution(solution, index),
          solution: solution,
        ),
        barrierColor: Colors.transparent,
      ),
    );
  }

  Row isOkCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: !isOkResponse,
          onChanged: (!isUpdatingResponse)
              ? (newValue) => toggleCheckbox(newValue)
              : null,
        ),
        Text('This response is linked to some problem'),
      ],
    );
  }

  Widget descriptionInput() {
    return BaseInput(
      title: 'Response description',
      controller: descriptionController,
      width: 250,
      hintText: 'Yes, no, etc.',
    );
  }

  void addListeners() {
    // To notify when this text field changes, so the finish button gets enabled or disabled.
    descriptionController.addListener(() => setState(() {}));
  }

  void createSolution(Solution solution) {
    solutions.add(solution);
    setState(() {});
  }

  void updateSolution(Solution solution, int index) {
    solutions[index] = solution;
    setState(() {});
  }

  void onFinish() {
    widget.callback(UserResponse(
      id: Uuid().v4(),
      description: descriptionController.text,
      isOkResponse: isOkResponse,
      solutions: solutions,
    ));
    Navigator.pop(context);
  }

  void toggleCheckbox(newValue) {
    if (newValue != null) isOkResponse = !newValue;

    setState(() {});
  }
}
