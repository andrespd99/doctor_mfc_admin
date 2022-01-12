import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/component.dart';
import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/services/database.dart';
import 'package:doctor_mfc_admin/widgets/custom_loading_indicator.dart';
import 'package:doctor_mfc_admin/widgets/future_loading_indicator.dart';
import 'package:doctor_mfc_admin/widgets/green_elevated_button.dart';
import 'package:doctor_mfc_admin/widgets/known_problem_dialog.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader_with_add_button.dart';

import 'package:doctor_mfc_admin/widgets/body_template.dart';
import 'package:doctor_mfc_admin/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class ComponentDetailsPage extends StatefulWidget {
  final System system;
  final Component component;

  ComponentDetailsPage({
    Key? key,
    required this.system,
    required this.component,
  }) : super(key: key);

  @override
  _ComponentDetailsPageState createState() => _ComponentDetailsPageState();
}

class _ComponentDetailsPageState extends State<ComponentDetailsPage> {
  late System system;
  late Component component;

  late bool manageModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<System>>(
        stream: Database().getSystemSnapshotById(widget.system.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            system = snapshot.data!.data()!;
            component = system.getComponent(widget.component.id);

            return BodyTemplate(
              title: component.description,
              subtitle: system.description,
              body: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SectionSubheaderWithAddButton(
                      title: 'Known problems',
                      addButtonText: 'Add known problem',
                      onPressed:
                          (manageModeEnabled) ? null : () => onAddPressed(),
                    ),
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
                knownProblemsList(),
              ],
            );
          } else
            return CustomLoadingIndicator();
        });
  }

  Widget knownProblemsList() {
    if (component.problems.isNotEmpty) {
      List<Problem> problems = component.problems;

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
                      callback: (newProblem) => updateProblem(
                        system: system,
                        problem: newProblem,
                      ),
                      subtitle: widget.component.description,
                    );
                  },
                );
              },
              showDeleteButton: manageModeEnabled,
              onDelete: () => promptDelete(problem),
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

  void updateProblem({required System system, required Problem problem}) {
    component.updateKnownProblem(problem);

    system.updateComponent(widget.component);

    futureLoadingIndicator(context, Database().updateSystem(system));
  }

  void onAddPressed() {
    showDialog(
        context: context,
        builder: (context) {
          return KnownProblemDialog(
            subtitle: component.description,
            callback: (problem) => addKnownProblem(problem),
          );
        });
  }

  void addKnownProblem(Problem problem) {
    system.getComponent(component.id).addKnownProblem(problem);

    futureLoadingIndicator(context, Database().updateSystem(system));
  }

  void toggleManageMode() {
    setState(() {
      manageModeEnabled = !manageModeEnabled;
    });
  }

  void deleteKnownProblem(Problem problem) {
    system.getComponent(component.id).deleteKnownProblem(problem);

    futureLoadingIndicator(context, Database().updateSystem(system))
        .then((value) => Navigator.pop(context));
  }

  void promptDelete(Problem problem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete known problem'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Confirm you want to delete the problem:'),
              Text(
                '${problem.description}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          buttonPadding: EdgeInsets.all(kDefaultPadding),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => deleteKnownProblem(problem),
              child: Text('Delete'),
              style: TextButton.styleFrom(primary: kAccentColor),
            ),
            GreenElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
