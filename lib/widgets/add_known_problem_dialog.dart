import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/user_response.dart';
import 'package:doctor_mfc_admin/widgets/add_user_response_dialog.dart';
import 'package:doctor_mfc_admin/widgets/custom_alert_dialog.dart';
import 'package:doctor_mfc_admin/widgets/object_elevated_button.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader_with_add_button.dart';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddKnownProblemDialog extends StatefulWidget {
  final Function(Problem) callback;
  final Problem? problem;

  const AddKnownProblemDialog({
    required this.callback,
    this.problem,
    Key? key,
  }) : super(key: key);

  @override
  State<AddKnownProblemDialog> createState() => _AddKnownProblemDialogState();
}

class _AddKnownProblemDialogState extends State<AddKnownProblemDialog> {
  // TextField controllers.
  final descriptionController = TextEditingController();
  final questionController = TextEditingController();
  final keywordController = TextEditingController();

  // List of keywords added by the user.
  late List<String> keywords = [];

  // Dimensions.
  double keywordBubbleHeight = 45.0;

  List<UserResponse> userResponses = [];

  // Getters
  bool get isUpdatingProblem => widget.problem != null;
  bool get keywordIsEmpty => keywordController.text.isEmpty;
  bool get canFinish {
    if (descriptionController.text.isNotEmpty &&
        questionController.text.isNotEmpty &&
        userResponses.length >= 2) {
      return true;
    } else
      return false;
  }

  @override
  void initState() {
    if (isUpdatingProblem) {
      Problem problem = widget.problem!;
      descriptionController.text = problem.description;
      questionController.text = problem.question;
      keywords = problem.keywords;
      userResponses = problem.userResponses ?? [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addListeners();

    return CustomAlertDialog(
      title: 'Add known problem',
      body: [
        problemDescriptionInput(),
        SizedBox(height: kDefaultPadding),
        questionInput(),
        SizedBox(height: kDefaultPadding),
        keywordsSection(),
        SizedBox(height: kDefaultPadding),
        userResponsesSection(),
      ],
      finishButtonTitle: isUpdatingProblem ? 'Update problem' : 'Add problem',
      onFinish: () => onFinish(),
      isButtonEnabled: canFinish,
    );
  }

  Column userResponsesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionSubheaderWithAddButton(
          title: 'User responses',
          onPressed: navigateToResponseCreation,
          addButtonText: 'Add responses',
        ),
        SizedBox(height: kDefaultPadding / 4),
        SizedBox(
          height: 55,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: userResponses.length,
            itemBuilder: (context, i) => ObjectElevatedButton(
              title: '${userResponses[i].description}',
              onPressed: () => navigateToResponseUpdate(
                userResponse: userResponses[i],
                index: i,
              ),
              width: 150,
            ),
            separatorBuilder: (context, i) =>
                SizedBox(width: kDefaultPadding / 2),
          ),
        ),
      ],
    );
  }

  Widget keywordsSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'Keywords',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(width: kDefaultPadding / 3),
            Text(
              '(Used in search)',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        SizedBox(height: kDefaultPadding / 2),
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.05)],
              stops: [0.9, 1],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  keywordInput(),
                  SizedBox(width: kDefaultPadding),
                  ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: keywords.length,
                    itemBuilder: (context, i) {
                      return keywordBubble(i);
                    },
                    separatorBuilder: (context, i) =>
                        SizedBox(width: kDefaultPadding / 2),
                  ),
                  SizedBox(width: kDefaultPadding * 2),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row keywordBubble(int i) {
    // Where delete button is shown.
    var rightSide = Container(
      height: keywordBubbleHeight,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(kDefaultBorderRadius),
        ),
      ),
      child: Center(
        child: IconButton(
          onPressed: () => onRemoveButtonPressed(i),
          icon: Icon(Icons.remove),
          color: Colors.grey,
        ),
      ),
    );
    // Where keyword text is shown.
    var leftSide = Container(
      height: keywordBubbleHeight,
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding / 1.5,
      ),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(kDefaultBorderRadius),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            keywords[i],
            style: TextStyle(color: kFontWhite),
          ),
        ],
      ),
    );

    return Row(
      children: [
        leftSide,
        rightSide,
      ],
    );
  }

  Container keywordInput() {
    return Container(
      width: 150,
      child: TextField(
        decoration: InputDecoration(
          suffixIcon: IconButton(
            enableFeedback: !keywordIsEmpty,
            onPressed: () => onAddButtonPressed(),
            icon: Icon(Icons.add),
            // color: (!keywordIsEmpty) ? kPrimaryColor : Colors.grey,
          ),
        ),
        onChanged: (value) => setState(() {}),
        controller: keywordController,
      ),
    );
  }

  Column problemDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description of the problem',
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: kDefaultPadding / 2),
        TextField(
          decoration: InputDecoration(
              hintText: 'Problem connecting to other devices via Bluetooth'),
          controller: descriptionController,
        ),
      ],
    );
  }

  Column questionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Troubleshooting question',
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: kDefaultPadding / 2),
        TextField(
          decoration:
              InputDecoration(hintText: 'Can you connect to another device? '),
          controller: questionController,
        ),
      ],
    );
  }

  Widget userResponseCard({
    required UserResponse userResponse,
    required int index,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.grey,
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding / 2,
          vertical: 0,
        ),
      ),
      onPressed: () =>
          navigateToResponseUpdate(userResponse: userResponse, index: index),
      child: Text(
        '${userResponse.description}',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Future<dynamic> navigateToResponseCreation() {
    return Navigator.push(
      context,
      DialogRoute(
        context: context,
        builder: (context) => AddUserResponseDialog(
          callback: (userResponse) => createResponse(userResponse),
        ),
        barrierColor: Colors.transparent,
      ),
    );
  }

  Future<dynamic> navigateToResponseUpdate({
    required UserResponse userResponse,
    required int index,
  }) {
    return Navigator.push(
      context,
      DialogRoute(
        context: context,
        builder: (context) => AddUserResponseDialog(
          callback: (updatedResponse) =>
              updateResponse(userResponse: updatedResponse, index: index),
          userResponse: userResponse,
        ),
        barrierColor: Colors.transparent,
      ),
    );
  }

  void addKeyword(String keyword) => this.keywords.add(keyword);
  void removeKeyword(int i) => keywords.removeAt(i);

  void onAddButtonPressed() {
    if (!keywordIsEmpty) {
      addKeyword(keywordController.text);
      keywordController.clear();
      setState(() {});
    }
  }

  void onRemoveButtonPressed(int i) {
    removeKeyword(i);
    setState(() {});
  }

  void createResponse(UserResponse userResponse) {
    userResponses.add(userResponse);
    setState(() {});
  }

  void updateResponse({
    required UserResponse userResponse,
    required int index,
  }) {
    userResponses[index] = userResponse;
    setState(() {});
  }

  void addListeners() {
    descriptionController.addListener(() => setState(() {}));
    questionController.addListener(() => setState(() {}));
  }

  void onFinish() {
    widget.callback(Problem(
      id: Uuid().v4(),
      description: descriptionController.text,
      keywords: keywords,
      question: questionController.text,
      userResponses: userResponses,
    ));

    Navigator.pop(context);
  }
}
