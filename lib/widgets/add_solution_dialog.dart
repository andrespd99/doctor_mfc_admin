import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/widgets/base_input.dart';
import 'package:doctor_mfc_admin/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class AddSolutionDialog extends StatefulWidget {
  final Function(Solution) callback;
  final Solution? solution;

  AddSolutionDialog({
    required this.callback,
    this.solution,
    Key? key,
  }) : super(key: key);

  @override
  _AddSolutionDialogState createState() => _AddSolutionDialogState();
}

class _AddSolutionDialogState extends State<AddSolutionDialog> {
  final descriptionController = TextEditingController();
  final instructionsController = TextEditingController();
  final videoLinkController = TextEditingController();

  int get instructionsLength => instructionsController.text.length;

  @override
  void initState() {
    if (widget.solution != null) {
      Solution solution = widget.solution!;

      descriptionController.text = solution.description;
      instructionsController.text = solution.instructions;
      videoLinkController.text =
          (solution.guideLink != null) ? solution.guideLink! : '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    videoLinkController.addListener(() {
      setState(() {});
    });

    return CustomAlertDialog(
      title: 'Add solution',
      body: [
        BaseInput(
            title: 'Solution description', controller: descriptionController),
        SizedBox(height: kDefaultPadding),
        instructionsInput(),
        SizedBox(height: kDefaultPadding),
        BaseInput(
          title: 'Video link',
          subtitle: '(optional)',
          controller: videoLinkController,
          hintText: 'https://www.youtube.com/some_video',
          errorText: errorText(),
        ),
      ],
      finishButtonTitle:
          (widget.solution == null) ? 'Add solution' : 'Update solution',
      onFinish: () => onFinish(),
      isButtonEnabled: canFinish(),
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

  bool canFinish() {
    if (descriptionController.text.isNotEmpty &&
        instructionsLength >= 120 &&
        isValidLink())
      return true;
    else
      return false;
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

  /// When on finish, returns a Solution object and goes back to last page.
  void onFinish() {
    widget.callback(new Solution(
      description: descriptionController.text,
      instructions: instructionsController.text,
      guideLink: (videoLinkController.text.isNotEmpty)
          ? videoLinkController.text
          : null,
    ));

    Navigator.pop(context);
  }
}
