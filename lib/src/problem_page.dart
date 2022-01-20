import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/src/solution_page.dart';
import 'package:doctor_mfc_admin/widgets/body_template.dart';
import 'package:doctor_mfc_admin/widgets/custom_card.dart';
import 'package:doctor_mfc_admin/widgets/object_elevated_button.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader_with_add_button.dart';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProblemPage extends StatefulWidget {
  final Function(Problem) callback;
  final Problem? problem;
  final String subtitle;

  const ProblemPage({
    required this.callback,
    required this.subtitle,
    this.problem,
    Key? key,
  }) : super(key: key);

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  // TextField controllers.
  final descriptionController = TextEditingController();
  final keywordController = TextEditingController();

  // List of keywords.
  late List<String> keywords = [];

  // List of solutions for this problem.
  List<Solution> solutions = [];

  // Dimensions.
  double keywordBubbleHeight = 45.0;

  bool manageModeEnabled = false;

  bool get isUpdatingProblem => widget.problem != null;
  bool get keywordIsEmpty => keywordController.text.isEmpty;

  String get problemDescription => descriptionController.text;

  bool get canFinish {
    if (problemDescription.isNotEmpty && solutions.isNotEmpty) {
      return true;
    } else
      return false;
  }

  @override
  void initState() {
    if (isUpdatingProblem) {
      Problem problem = widget.problem!;

      descriptionController.text = problem.description;

      keywords = problem.keywords;

      solutions.addAll(problem.solutions);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addListeners();

    return BodyTemplate(
      title: 'Add known problem',
      subtitle: widget.subtitle,
      body: [
        problemDescriptionInput(),
        SizedBox(height: kDefaultPadding),
        keywordsSection(),
        SizedBox(height: kDefaultPadding),
        ...solutionsSection(),
        SizedBox(height: kDefaultPadding * 3),
        Center(
          child: ElevatedButton(
            child: Text(isUpdatingProblem ? 'Save' : 'Create problem'),
            onPressed: (canFinish) ? () => onFinish() : null,
          ),
        ),
      ],
    );
  }

  List<Widget> solutionsSection() {
    return [
      SectionSubheaderWithButton(
        title: 'Solutions',
        buttonText: 'Add solution',
        onPressed: () => navigateToSolutionPage(),
        enableManageButton: true,
        onManageButtonPressed: () => toggleManageMode(),
        manageModeEnabled: manageModeEnabled,
      ),
      SizedBox(height: kDefaultPadding / 3),
      ListView.separated(
        shrinkWrap: true,
        itemCount: solutions.length,
        itemBuilder: (BuildContext context, int i) {
          return Row(
            children: [
              Expanded(
                child: ObjectElevatedButton(
                  title: solutions[i].description,
                  onPressed: () => navigateToSolutionPage(solutions[i]),
                ),
              ),
              manageModeEnabled
                  ? TextButton(
                      child: Text('Delete'),
                      onPressed: () => deleteSolution(i),
                      style: TextButton.styleFrom(primary: Colors.red),
                    )
                  : Container(),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int i) =>
            SizedBox(height: kDefaultPadding / 3),
      ),
    ];
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

  void addListeners() {
    descriptionController.addListener(() => setState(() {}));
  }

  void onFinish() {
    Navigator.pop(context);

    widget.callback(
      Problem(
        id: (widget.problem != null) ? widget.problem!.id : Uuid().v4(),
        description: descriptionController.text,
        keywords: keywords,
        solutions: solutions,
      ),
    );
  }

  navigateToSolutionPage([Solution? solution]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SolutionPage(
          solution: solution,
          subtitle: problemDescription,
          callback: (newSolution) {
            (solution != null)
                ? updateSolution(solution, newSolution)
                : addSolution(newSolution);
          },
        ),
      ),
    );
  }

  addSolution(Solution newSolution) {
    solutions.add(newSolution);
    setState(() {});
  }

  updateSolution(Solution oldSolution, Solution newSolution) {
    solutions[solutions.indexOf(oldSolution)] = newSolution;
    setState(() {});
  }

  void toggleManageMode() {
    manageModeEnabled = !manageModeEnabled;
    setState(() {});
  }

  void deleteSolution(int i) {
    solutions.removeAt(i);
    setState(() {});
  }
}
