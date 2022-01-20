import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/attachment.dart';
import 'package:doctor_mfc_admin/models/enums/attachment_type.dart';
import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/models/step.dart' as my;
import 'package:doctor_mfc_admin/services/current_system_selected_service.dart';
import 'package:doctor_mfc_admin/src/file_attatchment_edit_dialog.dart';
import 'package:doctor_mfc_admin/widgets/base_input.dart';
import 'package:doctor_mfc_admin/widgets/body_template.dart';

import 'package:doctor_mfc_admin/widgets/section_subheader.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader_with_add_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SolutionPage extends StatefulWidget {
  final Function(Solution) callback;
  final Solution? solution;
  final String subtitle;

  SolutionPage({
    required this.callback,
    required this.subtitle,
    this.solution,
    Key? key,
  }) : super(key: key);

  @override
  _SolutionPageState createState() => _SolutionPageState();
}

class _SolutionPageState extends State<SolutionPage> {
  final descriptionController = TextEditingController();
  final instructionsController = TextEditingController();
  final videoLinkController = TextEditingController();

  List<StepController> stepsControllers = [];

  int get instructionsLength => instructionsController.text.length;
  bool get fieldsAreNotEmpty => descriptionController.text.isNotEmpty;

  bool? isStepBased;

  bool stepManageModeEnabled = false;

  late List<my.Step> steps = [];

  List<Attachment> attachments = [];
  bool attachmentsManageModeEnabled = false;

  @override
  void initState() {
    if (widget.solution != null) {
      Solution solution = widget.solution!;
      descriptionController.text = solution.description;
      attachments = solution.attachments ?? [];
      // Check whether the solution is step-based or not.
      if (solution.steps != null && solution.steps!.isNotEmpty) {
        isStepBased = true;
        steps = solution.steps!;

        steps.forEach((step) => addStepControllers(step));
      } else {
        isStepBased = false;
        instructionsController.text = solution.instructions!;
      }
      // videoLinkController.text =
      //     (solution.links != null) ? solution.links! : '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addListenersTo([videoLinkController, descriptionController]);

    return BodyTemplate(
      title: 'Add solution',
      subtitle: widget.subtitle,
      body: [
        BaseInput(
            title: 'Solution description', controller: descriptionController),
        SizedBox(height: kDefaultPadding),
        (isStepBased == null) ? askSolutionTypeSection() : solutionGuideInput(),
        // SizedBox(height: kDefaultPadding),
        // videoLinkInput(),
        SizedBox(height: kDefaultPadding),
        attatchmentsList(),
        SizedBox(height: kDefaultPadding * 3),
        finishButton(),
      ],
    );
  }

  BaseInput videoLinkInput() {
    return BaseInput(
      title: 'Video link',
      subtitle: '(optional)',
      controller: videoLinkController,
      hintText: 'https://www.youtube.com/some_video',
      errorText: errorText(),
    );
  }

  Column attatchmentsList() {
    final dropdownItems = [
      DropdownMenuItem(
        child: Text('Link'),
        value: AttachmentType.LINK,
      ),
      DropdownMenuItem(
        child: Text('Documentation'),
        value: AttachmentType.DOCUMENTATION,
      ),
      DropdownMenuItem(
        child: Text('Guide'),
        value: AttachmentType.GUIDE,
      ),
    ];

    return Column(
      children: [
        SectionSubheaderWithButton(
          title: 'Links, docs and guides',
          buttonText: 'Add',
          onPressed: () => addNewAttatchment(),
          enableManageButton: true,
          onManageButtonPressed: () => toggleAttachmentsManageMode(),
          manageModeEnabled: attachmentsManageModeEnabled,
        ),
        SizedBox(height: kDefaultPadding / 2),
        ListView.separated(
          shrinkWrap: true,
          itemCount: attachments.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: kDefaultPadding / 3),
          itemBuilder: (context, i) {
            return Row(
              children: [
                DropdownButton<AttachmentType>(
                  items: dropdownItems,
                  onChanged: (selectedType) =>
                      changeAttachmentType(i, selectedType),
                  value: attachments[i].type,
                ),
                SizedBox(width: kDefaultPadding / 2),
                ...attachmentTileWidgets(attachments[i]),
                attachmentsManageModeEnabled
                    ? TextButton(
                        child: Text('Delete'),
                        style: TextButton.styleFrom(primary: Colors.red),
                        onPressed: () => removeAttachment(i),
                      )
                    : Container(),
              ],
            );
          },
        ),
      ],
    );
  }

  List<Widget> attachmentTileWidgets(Attachment attachment) {
    if (attachment is LinkAttachment) {
      // Attachment is a link.
      return [
        Expanded(
          child: TextField(
            controller: attachment.controller.url,
            decoration: InputDecoration(
              labelText: 'Url',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: kDefaultPadding / 2),
        Expanded(
          child: TextField(
            controller: attachment.controller.title,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ];
    } else if (attachment is FileAttachment) {
      if (!attachment.isFileAttached) {
        // No attachment selected.
        return [
          ElevatedButton(
            child: Text('Attach'),
            onPressed: () => openAttachmentEditDialog(attachment),
          ),
        ];
      } else {
        // Attachment selected.
        return [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'File attached',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: kDefaultPadding / 4),
                Text('${attachment.fileName!}'),
              ],
            ),
          ),
          SizedBox(width: kDefaultPadding / 3),
          // Hide 'Change' button when manage mode is enabled.
          Align(
            alignment: Alignment.centerRight,
            child: attachmentsManageModeEnabled
                ? Container()
                : ElevatedButton(
                    child: Text('Change'),
                    onPressed: () => openAttachmentEditDialog(attachment),
                  ),
          ),
        ];
      }
    } else {
      return [];
    }
  }

  Center finishButton() {
    return Center(
      child: ElevatedButton(
        child: Text(
            (widget.solution == null) ? 'Create solution' : 'Update solution'),
        onPressed: canFinish ? () => onFinish() : null,
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionSubheaderWithButton(
            title: 'Steps',
            buttonText: 'Add step',
            onPressed: () => addStep(),
            enableManageButton: true,
            onManageButtonPressed: () => toggleStepManageMode(),
            manageModeEnabled: stepManageModeEnabled,
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
                    Expanded(
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
                    (stepManageModeEnabled && i != 0)
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
                                  Expanded(
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
                                  (stepManageModeEnabled)
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

  bool get canFinish {
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
    if (isStepBased! && steps.last.description.isEmpty) steps.removeLast();

    widget.callback(
      new Solution(
        id: (widget.solution != null) ? widget.solution!.id : Uuid().v4(),
        description: descriptionController.text,
        instructions: instructionsController.text,
        steps: (isStepBased!) ? steps : null,
        attachments: attachments,
      ),
    );

    Navigator.pop(context);
  }

  bool isLastStep(my.Step step) => steps.last == step;

  bool stepHasEmptySubsteps(my.Step step) =>
      step.substeps.any((substep) => substep.isEmpty);

  void toggleStepManageMode() =>
      setState(() => stepManageModeEnabled = !stepManageModeEnabled);

  void onAttachmentCallback(FileAttachment attachment, int index) {
    attachments[index] = attachment;

    setState(() {});
  }

  void openAttachmentEditDialog(FileAttachment attachment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FileAttachmentEditDialog(
          attachment: attachment,
          onAttachmentCallback: (attachment) {
            setState(() {});
          },
        );
      },
    );
  }

/* ---------------------------- CRUD ATTACHMENTS ---------------------------- */
  void addNewAttatchment() {
    // Adds new attatchment to list.
    attachments.add(LinkAttachment());

    setState(() {});
  }

  void changeAttachmentType(int i, AttachmentType? selectedType) {
    String? systemId =
        Provider.of<CurrentSystemSelectedService>(context, listen: false)
            .currentSelectedSystem
            ?.id;

    assert(selectedType != null);
    assert(systemId != null);

    if (selectedType == AttachmentType.DOCUMENTATION ||
        selectedType == AttachmentType.GUIDE) {
      attachments[i] = FileAttachment(
        type: selectedType!,
        systemId: systemId!,
      );
    } else if (selectedType == AttachmentType.LINK) {
      attachments[i] = LinkAttachment();
    } else {
      throw Exception("Invalid attachment type.");
    }
    setState(() {});
  }

  void deleteAttachment(int i) {
    setState(() => attachments.removeAt(i));
  }

  void toggleAttachmentsManageMode() {
    attachmentsManageModeEnabled = !attachmentsManageModeEnabled;
    setState(() {});
  }

  void removeAttachment(int i) {
    attachments.removeAt(i);
    setState(() {});
  }
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
    substepControllers.removeRange(start, substepControllers.length);
    substepFocusNodes.removeRange(start, substepFocusNodes.length);
  }
}
