import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/user_response.dart';
import 'package:doctor_mfc_admin/widgets/user_response_dialog.dart';
import 'package:doctor_mfc_admin/widgets/custom_alert_dialog.dart';

import 'package:doctor_mfc_admin/widgets/section_subheader.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader_with_add_button.dart';
import 'package:doctor_mfc_admin/widgets/user_response_elevated_button.dart';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class KnownProblemDialog extends StatefulWidget {
  final Function(Problem) callback;
  final Problem? problem;
  final String subtitle;

  const KnownProblemDialog({
    required this.callback,
    required this.subtitle,
    this.problem,
    Key? key,
  }) : super(key: key);

  @override
  State<KnownProblemDialog> createState() => _KnownProblemDialogState();
}

class _KnownProblemDialogState extends State<KnownProblemDialog> {
  // TextField controllers.
  final descriptionController = TextEditingController();
  final questionController = TextEditingController();
  final keywordController = TextEditingController();

  // List of keywords added by the user.
  late List<String> keywords = [];

  // Dimensions.
  double keywordBubbleHeight = 45.0;

  List<UserResponse> userResponses = [];

  /// Whether this question is a yes/no (binary) question or a multiple options
  /// question.
  bool? isMultiOptions;

  String get question => questionController.text;

  bool get isUpdatingProblem => widget.problem != null;
  bool get keywordIsEmpty => keywordController.text.isEmpty;

  bool get canFinish {
    if (fieldsAreNotEmpty && hasValidUserResponses()) {
      return true;
    } else
      return false;
  }

  /// Returns true if description and question fields are NOT empty.
  bool get fieldsAreNotEmpty =>
      descriptionController.text.isNotEmpty &&
      questionController.text.isNotEmpty;

  @override
  void initState() {
    if (isUpdatingProblem) {
      Problem problem = widget.problem!;
      descriptionController.text = problem.description;
      questionController.text = problem.question;
      keywords = problem.keywords;
      userResponses = problem.userResponses;
      isMultiOptions = problem.isMultiOptions;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addListeners();

    return CustomAlertDialog(
      title: 'Add known problem',
      subtitle: widget.subtitle,
      body: [
        problemDescriptionInput(),
        SizedBox(height: kDefaultPadding),
        questionInput(),
        SizedBox(height: kDefaultPadding),
        keywordsSection(),
        SizedBox(height: kDefaultPadding),
        // First, user has to select what type of question this is
        // (in askQuestionTypeSection()), then the user responses section is shown.
        (userResponses.isEmpty && isMultiOptions == null)
            ? askQuestionTypeSection()
            : userResponsesSection(),
      ],
      finishButtonTitle: isUpdatingProblem ? 'Save' : 'Add problem',
      onFinish: () => onFinish(),
      isButtonEnabled: canFinish,
    );
  }

  Column askQuestionTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionSubheader('User responses'),
        SizedBox(height: kDefaultPadding / 4),
        Text('Is this a yes/no question or a multiple options question?'),
        ButtonBar(
          alignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: (fieldsAreNotEmpty)
                  ? () => setState(() => setAsBinaryQuestion())
                  : null,
              child: Text('Yes/no question'),
            ),
            ElevatedButton(
              onPressed: (fieldsAreNotEmpty)
                  ? () => setState(() => setAsMultiOptionQuestion())
                  : null,
              child: Text('Multiple options question'),
            ),
          ],
        )
      ],
    );
  }

  Column userResponsesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionSubheaderWithAddButton(
          title: 'User responses',
          onPressed:
              (isMultiOptions!) ? () => navigateToResponseCreation() : null,
          addButtonText: 'Add responses',
        ),
        SizedBox(height: kDefaultPadding / 4),
        SizedBox(
          height: 55,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: userResponses.length,
            itemBuilder: (context, i) => UserResponseElevatedButton(
              response: userResponses[i],
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
        SizedBox(height: kDefaultPadding / 2),
        (isMultiOptions == false) ? swapOkResponseButton() : Container(),
      ],
    );
  }

  Widget swapOkResponseButton() {
    return TextButton(
      style: TextButton.styleFrom(primary: kSecondaryColor),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.swap_horiz),
          SizedBox(width: kDefaultPadding / 3),
          Text(
            'Swap OK response',
          ),
        ],
      ),
      onPressed: () => swapOkResponse(),
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
        builder: (context) => UserResponseDialog(
          question: question,
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
        builder: (context) => UserResponseDialog(
          question: question,
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
    Navigator.pop(context);

    widget.callback(
      Problem(
        id: Uuid().v4(),
        description: descriptionController.text,
        keywords: keywords,
        question: questionController.text,
        userResponses: userResponses,
        isMultiOptions: this.isMultiOptions!,
      ),
    );
  }

  /// Sets the question of this [KnownProblem] as a binary question.
  void setAsBinaryQuestion() {
    isMultiOptions = false;
    userResponses.addAll([
      // Add 'Yes' response.
      UserResponse(
        id: Uuid().v4(),
        isOkResponse: true,
        description: 'Yes',
      ),
      // Add 'No' response.
      UserResponse(
        id: Uuid().v4(),
        isOkResponse: false,
        description: 'No',
      )
    ]);
  }

  void setAsMultiOptionQuestion() {
    isMultiOptions = true;
  }

  /// In order for this question to be valid, there has to be at least one
  /// working response (okResponse) and one failing response (notOkResponse).
  ///
  /// If this criteria is not met, the user can't complete the creation of the
  /// problem.
  bool hasValidUserResponses() {
    bool hasOkResponse = false;
    bool hasNotOkResponse = false;

    userResponses.forEach((response) {
      if (response.isOkResponse) {
        hasOkResponse = true;
      } else if (!response.isOkResponse) {
        hasNotOkResponse = true;
      }
    });

    return hasOkResponse && hasNotOkResponse;
  }

  void swapOkResponse() {
    final notOkResponse =
        userResponses.firstWhere((response) => response.isOkResponse == false);

    if (notOkResponse.solutions.length > 0)
      promptSwapOkResponse();
    else
      setState(() {
        userResponses.forEach((response) {
          response.isOkResponse = !response.isOkResponse;
        });
      });
  }

  promptSwapOkResponse() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm swapping responses'),
          content: Text(
              'Are you sure you want to swap the OK response? This will also delete the solutions of the current OK response.'),
          actions: [
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                primary: kAccentColor,
              ),
            ),
            ElevatedButton(
              child: Text('Swap'),
              onPressed: () {
                setState(() {
                  // Clear all solutions of the current failing response.
                  userResponses
                      .firstWhere((response) => response.isOkResponse == false)
                      .solutions
                      .clear();
                  // Swap responses
                  userResponses.forEach((response) {
                    response.isOkResponse = !response.isOkResponse;
                  });
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
