import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/solution.dart';

class Component {
  final String id;
  final String description;
  final List<Problem> problems;

  Component({
    required this.id,
    required this.description,
    required this.problems,
  });

  factory Component.fromMap(Map<String, dynamic> data) {
    return Component(
      id: data['id'],
      description: data['description'],
      problems: _getProblems(List.from(data['problems'] ?? [])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'problems': _problemsToMap(),
    };
  }

  List<Map<String, dynamic>> _problemsToMap() =>
      problems.map((problem) => problem.toMap()).toList();

  /// Returns a List of [Problem] from a json map.
  static List<Problem> _getProblems(List<Map<String, dynamic>>? data) {
    if (data != null)
      return data.map((problemData) => Problem.fromMap(problemData)).toList();
    else
      return [];
  }

  void addKnownProblem(Problem problem) => problems.add(problem);

  /// Updates the given known problem for this component.
  void updateKnownProblem(Problem problemUpdated) {
    problems.forEach((problem) {
      if (problem.id == problemUpdated.id) {
        problem = problemUpdated;
      }
    });
  }

  void deleteKnownProblem(Problem problem) => problems.remove(problem);

  /// List of all solutions linked to this component.
  List<Solution> get solutions {
    List<Solution> solutions = [];
    problems.forEach((problem) {
      problem.userResponses.forEach((response) {
        solutions.addAll(response.solutions);
      });
    });
    return solutions;
  }
}
