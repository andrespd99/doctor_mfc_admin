import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/component.dart';
import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/services/database.dart';
import 'package:doctor_mfc_admin/widgets/future_loading_indicator.dart';
import 'package:doctor_mfc_admin/widgets/known_problem_dialog.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader_with_add_button.dart';

import 'package:doctor_mfc_admin/widgets/body_template.dart';
import 'package:doctor_mfc_admin/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class ComponentDetailsPage extends StatefulWidget {
  final System system;
  final Component component;
  final String systemName;

  ComponentDetailsPage({
    Key? key,
    required this.system,
    required this.component,
    required this.systemName,
  }) : super(key: key);

  @override
  _ComponentDetailsPageState createState() => _ComponentDetailsPageState();
}

class _ComponentDetailsPageState extends State<ComponentDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BodyTemplate(
      title: widget.component.description,
      subtitle: widget.systemName,
      body: [
        SectionSubheaderWithAddButton(
          title: 'Known problems',
          onPressed: () {},
          addButtonText: 'Add known problem',
        ),
        SizedBox(height: kDefaultPadding / 2),
        knownProblemsList(),
      ],
    );
  }

  StatelessWidget knownProblemsList() {
    if (widget.component.problems.isNotEmpty) {
      List<Problem> problems = widget.component.problems;

      return ListView.separated(
        shrinkWrap: true,
        itemCount: problems.length,
        itemBuilder: (context, i) {
          Problem problem = problems[i];

          return Align(
            alignment: Alignment.centerLeft,
            child: CustomCard(
              title: problem.description,
              subtitle: problem.question,
              body: [
                failureOptionsCountText(problem.failureOptionsCount),
                SizedBox(height: kDefaultPadding / 6),
                Text('${problem.solutions.length} solutions'),
              ],
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return KnownProblemDialog(
                      problem: problem,
                      callback: (newProblem) => updateProblem(newProblem),
                      subtitle: widget.component.description,
                    );
                  },
                );
              },
            ),
          );
        },
        separatorBuilder: (context, i) {
          return SizedBox(height: kDefaultPadding / 2);
        },
      );
    } else
      return Text('None', style: TextStyle(color: Colors.grey));
  }

  Text failureOptionsCountText(int count) {
    if (count == 0)
      return Text('No failure options');
    else if (count == 1)
      return Text('$count failure option');
    else
      return Text('$count failure options');
  }

  void updateProblem(Problem newProblem) {
    widget.component.updateKnownProblem(newProblem);

    widget.system.updateComponent(widget.component);

    futureLoadingIndicator(context, Database().updateSystem(widget.system));
  }
}
