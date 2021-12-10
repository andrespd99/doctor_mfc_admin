import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/models/step.dart' as my;
import 'package:doctor_mfc_admin/widgets/base_input.dart';
import 'package:doctor_mfc_admin/widgets/custom_alert_dialog.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class SolutionDialog extends StatefulWidget {
  final Function(Solution) callback;
  final Solution? solution;
  final String subtitle;

  SolutionDialog({
    required this.callback,
    required this.subtitle,
    this.solution,
    Key? key,
  }) : super(key: key);

  @override
  _SolutionDialogState createState() => _SolutionDialogState();
}

class _SolutionDialogState extends State<SolutionDialog> {
  final descriptionController = TextEditingController();
  final instructionsController = TextEditingController();
  final videoLinkController = TextEditingController();

  List<StepController> stepsControllers = [];

  int get instructionsLength => instructionsController.text.length;
  bool get fieldsAreNotEmpty => descriptionController.text.isNotEmpty;

  bool? isStepBased;
  bool manageModeEnabled = false;

  late List<my.Step> steps = [];

  @override
  void initState() {
    if (widget.solution != null) {
      Solution solution = widget.solution!;
      descriptionController.text = solution.description;
      // Check whether the solution is step-based or not.
      if (solution.steps != null && solution.steps!.isNotEmpty) {
        isStepBased = true;
        steps = solution.steps!;

        steps.forEach((step) => addStepControllers(step));
      } else {
        isStepBased = false;
        instructionsController.text = solution.instructions!;
      }

      videoLinkController.text =
          (solution.guideLink != null) ? solution.guideLink! : '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addListenersTo([videoLinkController, descriptionController]);

    return CustomAlertDialog(
      title: 'Add solution',
      subtitle: widget.subtitle,
      body: [
        BaseInput(
            title: 'Solution description', controller: descriptionController),
        SizedBox(height: kDefaultPadding),
        (isStepBased == null) ? askSolutionTypeSection() : solutionGuideInput(),
        SizedBox(height: kDefaultPadding),
        BaseInput(
          title: 'Video link',
          subtitle: '(optional)',
          controller: videoLinkController,
          hintText: 'https://www.youtube.com/some_video',
          errorText: errorText(),
        ),
      ],
      finishButtonTitle: (widget.solution == null) ? 'Save' : 'Update solution',
      onFinish: () => onFinish(),
      isButtonEnabled: canFinish(),
    );
  }

  Column askSolutionTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionSubheader('Guide by steps or by an instruction?'),
        SizedBox(height: kDefaultPadding / 4),
        ButtonBar(
          alignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: (fieldsAreNotEmpty)
                  ? () => setState(() => setStepBased())
                  : null,
              child: Text('Steps'),
            ),
            ElevatedButton(
              onPressed: (fieldsAreNotEmpty)
                  ? () => setState(() => isStepBased = false)
                  : null,
              child: Text('Instruction'),
            ),
          ],
        )
      ],
    );
  }

  Column instructionsInput() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Instructions ($instructionsLength)',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(width: kDefaultPadding / 2),
            Text(
              'At least 120 characters',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
        SizedBox(height: kDefaultPadding / 2),
        Container(
          constraints: BoxConstraints(maxHeight: 200),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 5,
            controller: instructionsController,
            onChanged: (value) => setState(() {}),
          ),
        ),
      ],
    );
  }

  bool isValidLink() {
    RegExp regExp = new RegExp(
      r"[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)",
      caseSensitive: true,
      multiLine: false,
    );

    if (videoLinkController.text.isNotEmpty) {
      if (regExp.hasMatch(videoLinkController.text))
        // Input is a valid link
        return true;
      else
        // Input is not a valid link
        return false;
    }
    return true;
  }

  /// Returns the error text if video link doesn't match.
  String? errorText() {
    if (!isValidLink()) {
      return 'This is not a valid link';
    }
  }

  Widget solutionGuideInput() {
    if (isStepBased!) {
      return stepsInput();
    } else {
      return instructionsInput();
    }
  }

  void setStepBased() {
    steps.add(my.Step(description: ''));
    stepsControllers.add(StepController(TextEditingController()));
    isStepBased = true;
  }

  void addStepControllers(my.Step step) => stepsControllers.add(
        StepController(
          TextEditingController(text: step.description),
          substepControllers: step.substeps
              .map((substep) => TextEditingController(text: substep))
              .toList(),
        ),
      );

  Text stepText(String step) {
    return Text(
      step,
      style: TextStyle(
        color: kPrimaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget stepsInput() {
    return Container(
      width: 100.00,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SectionSubheader('Steps'),
              TextButton(
                onPressed: () => toggleManageMode(),
                child: Text((!manageModeEnabled) ? 'Manage' : 'Finish'),
                style: TextButton.styleFrom(
                  primary: kFontBlack.withOpacity(0.5),
                ),
              ),
            ],
          ),
          SizedBox(height: kDefaultPadding / 2),
          ListView.separated(
            shrinkWrap: true,
            itemCount: steps.length,
            itemBuilder: (context, i) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${i + 1}.',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: kDefaultPadding / 2),
                    SizedBox(
                      width: 400,
                      child: TextField(
                        focusNode: stepsControllers[i].focusNode,
                        controller: stepsControllers[i].descriptionController,
                        onChanged: (value) => setState(() {
                          steps[i].description = value;
                        }),
                        onSubmitted: (value) => onSubmit(i),
                        decoration: InputDecoration(
                          suffixIcon: (i != 0)
                              ? IconButton(
                                  icon: Icon(Icons.format_indent_increase),
                                  onPressed: () => indentStepIn(i),
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(width: kDefaultPadding / 3),
                    (manageModeEnabled && i != 0)
                        ? IconButton(
                            icon: Icon(Icons.delete, color: Colors.black38),
                            onPressed: () => removeStep(i))
                        : Container(),
                  ],
                ),
                (steps[i].substeps.isNotEmpty)
                    ? Column(
                        children: [
                          SizedBox(height: kDefaultPadding / 2),
                          ListView.separated(
                            shrinkWrap: true,
                            itemCount: steps[i].substeps.length,
                            itemBuilder: (context, j) {
                              TextEditingController controller =
                                  stepsControllers[i].substepControllers[j];

                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  stepText('${i + 1}.${j + 1}. '),
                                  SizedBox(width: kDefaultPadding / 2),
                                  SizedBox(
                                    width: 400,
                                    child: TextField(
                                      focusNode: stepsControllers[i]
                                          .substepFocusNodes[j],
                                      controller: controller,
                                      onChanged: (value) => setState(() {
                                        steps[i].substeps[j] = value;
                                      }),
                                      onSubmitted: (value) => onSubmit(i, j),
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                              Icons.format_indent_decrease),
                                          onPressed: () => indentStepOut(i, j),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: kDefaultPadding / 3),
                                  (manageModeEnabled)
                                      ? IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.black38),
                                          onPressed: () => removeStep(i, j))
                                      : Container(),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: kDefaultPadding / 2),
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
            separatorBuilder: (context, index) =>
                SizedBox(height: kDefaultPadding / 2),
          )
        ],
      ),
    );
  }

  void indentStepIn(int index) {
    my.Step stepToIndent = steps[index];
    List<String> stepToIndentSubsteps = stepToIndent.substeps;

    steps[index - 1].addSubstep(stepToIndent.description);
    steps.removeAt(index);

    StepController controller = stepsControllers[index];
    stepsControllers[index - 1]
        .addSubstepController(controller.descriptionController);

    stepsControllers.removeAt(index);

    if (stepToIndentSubsteps.isNotEmpty) {
      stepToIndentSubsteps.forEach((substep) {
        steps[index - 1].addSubstep(substep);
        stepsControllers[index - 1]
            .addSubstepController(TextEditingController(text: substep));
      });
    }

    setState(() {});
  }

  void indentStepOut(int index, int subindex) {
    /// Indent step out
    String stepToIndentOutDesc = steps[index].substeps[subindex];
    steps.insert(index + 1, my.Step(description: stepToIndentOutDesc));
    steps[index].substeps.removeAt(subindex);

    // Reallocate the indented step's controller.
    TextEditingController controller =
        stepsControllers[index].substepControllers[subindex];
    stepsControllers.insert(index + 1, StepController(controller));
    stepsControllers[index].removeSubstepController(subindex);

    // Reallocate the following substeps.
    final auxSubstepControllers =
        stepsControllers[index].substepControllers.sublist(subindex);
    final auxSubsteps = steps[index].substeps.sublist(subindex);

    stepsControllers[index].removeSubstepControllersFrom(subindex);
    steps[index].substeps.removeRange(subindex, steps[index].substeps.length);

    auxSubstepControllers.forEach((substepController) {
      stepsControllers[index + 1].addSubstepController(substepController);
    });
    auxSubsteps.forEach((substep) {
      steps[index + 1].addSubstep(substep);
    });

    setState(() {});
  }

  void onSubmit(int index, [int? subindex]) {
    if (subindex != null) {
      bool isLastController =
          stepsControllers[index].substepControllers[subindex] ==
              stepsControllers[index].substepControllers.last;

      bool lastControllerIsEmpty =
          stepsControllers[index].substepControllers[subindex].text.isEmpty;

      if (isLastController && !lastControllerIsEmpty) {
        addSubstep(index);
      } else if (isLastController && lastControllerIsEmpty) {
        removeStep(index, subindex);
        if (steps[index] == steps.last) {
          addStep();
          requestFocusLastStep();
        } else {
          requestFocus(index + 1);
        }
      } else {
        requestFocus(index, subindex + 1);
      }
    } else {
      bool isLastController = stepsControllers[index] == stepsControllers.last;
      bool lastControllerNotEmpty =
          stepsControllers[index].descriptionController.text.isNotEmpty;

      if (isLastController && lastControllerNotEmpty) {
        addStep();
      } else if (!isLastController) {
        requestFocus(index + 1);
      } else if (index != 0) {
        removeStep(index);
      }
    }
    setState(() {});
  }

//* -------------------- Add/Remove steps and substeps. -------------------- */
  void addStep() {
    steps.add(my.Step(description: ""));

    stepsControllers.add(StepController(TextEditingController()));
    stepsControllers.last.focusNode.requestFocus();

    setState(() {});
  }

  void addSubstep(int index) {
    steps[index].addSubstep("");

    stepsControllers[index].addSubstepController(TextEditingController());

    FocusNode node = stepsControllers[index].substepFocusNodes.last;

    node.requestFocus();
    setState(() {});
  }

  void removeStep(int index, [int? subindex]) {
    if (steps.length > 1) {
      if (subindex != null) {
        steps[index].substeps.removeAt(subindex);
        stepsControllers[index].removeSubstepController(subindex);
      } else {
        steps.removeAt(index);
        stepsControllers.removeAt(index);
      }
    }
    setState(() {});
  }

//* -------------------------------------------------------------------------- */

  void requestFocus(int index, [int? subindex]) {
    if (subindex == null) {
      stepsControllers[index].focusNode.requestFocus();
    } else {
      stepsControllers[index].substepFocusNodes[subindex].requestFocus();
    }
  }

  void requestFocusLastStep() {
    stepsControllers.last.focusNode.requestFocus();
  }

  void addListenersTo(List<TextEditingController> controllers) {
    controllers
        .forEach((controller) => controller.addListener(() => setState(() {})));
  }

  bool canFinish() {
    if (descriptionController.text.isNotEmpty && isValidLink()) {
      if (isStepBased != null) {
        if (isStepBased!) {
          return true;
        } else if (instructionsController.text.isNotEmpty) {
          return true;
        } else
          return false;
      }
      return true;
    } else
      return false;
  }

  /// When on finish, returns a Solution object and goes back to last page.
  void onFinish() {
    if (steps.last.description.isEmpty) steps.removeLast();

    widget.callback(new Solution(
      id: Uuid().v4(),
      description: descriptionController.text,
      instructions: instructionsController.text,
      steps: (isStepBased!) ? steps : null,
      guideLink: (videoLinkController.text.isNotEmpty)
          ? videoLinkController.text
          : null,
    ));

    Navigator.pop(context);
  }

  // bool areStepsValid() {
  //   if (steps.length == 0 || anyInvalidSteps())
  //     return false;
  //   else
  //     return true;
  // }

  // bool isLastStep(my.Step step) => steps.last == step;

  // bool stepHasEmptySubsteps(my.Step step) =>
  //     step.substeps.any((substep) => substep.isEmpty);

  // bool anyInvalidSteps() {
  //   for (my.Step step in steps) {
  //     if (steps.length > 1 && isLastStep(step) && step.substeps.isEmpty) {
  //       // If its not the only step, is the last step, it has no substeps and is empty,
  //       // do nothing, it doesn't matter.
  //     } else if (isLastStep(step) && step.substeps.isNotEmpty) {
  //       // Last step description is empty but has substeps. Not valid.
  //       return true;
  //     } else if (step.description.isEmpty)
  //       return true;
  //     else if (stepHasEmptySubsteps(step)) return true;
  //   }
  //   return false;
  // }

  void toggleManageMode() =>
      setState(() => manageModeEnabled = !manageModeEnabled);
}

class StepController {
  TextEditingController descriptionController;

  List<TextEditingController> substepControllers = [];
  List<FocusNode> substepFocusNodes = [];

  FocusNode focusNode = new FocusNode();

  StepController(
    this.descriptionController, {
    List<TextEditingController>? substepControllers,
  }) {
    this.substepControllers.addAll(substepControllers ?? []);

    this
        .substepControllers
        .forEach((controller) => substepFocusNodes.add(FocusNode()));
  }

  void addSubstepController(TextEditingController controller) {
    substepControllers.add(controller);
    substepFocusNodes.add(new FocusNode());
  }

  /// Removes substep at `index`. If no `index` is given, removes the last substep.
  void removeSubstepController([int? index]) {
    substepControllers.removeAt(index ?? substepControllers.length - 1);
    substepFocusNodes.removeAt(index ?? substepFocusNodes.length - 1);
  }

  void removeSubstepControllersFrom(int start) {
    print('controllers length ${substepControllers.length}');
    print('focus nodes length ${substepFocusNodes.length}');

    print('controllers range: ${substepControllers.length - start}');
    print('focus nodes range: ${substepFocusNodes.length - start}');
    substepControllers.removeRange(start, substepControllers.length);
    substepFocusNodes.removeRange(start, substepFocusNodes.length);
  }
}
