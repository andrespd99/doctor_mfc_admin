import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/solution.dart';

class System {
  final String id;
  String description;
  String brand;

  final String type;
  final List<Problem> problems;

  System({
    required this.id,
    required this.description,
    required this.type,
    required this.brand,
    required this.problems,
  });

  factory System.fromMap({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return System(
      id: id,
      description: data['description'],
      type: data['type'],
      brand: data['brand'],
      problems: List.from(data['problems'])
          .map((problemData) => Problem.fromMap(problemData))
          .toList(),
      // components: _componentsFromMap(List.from(data['components'] ?? [])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'type': type.toLowerCase(),
      'brand': brand,
      'problems': problems.map((problem) => problem.toMap()).toList(),
      // 'components': _componentsToMap(),
    };
  }

  void deleteProblem(Problem problem) {
    problems.remove(problem);
  }

/* --------------------------------- Getters -------------------------------- */

  List<Solution> get solutions {
    List<Solution> solutions = [];

    problems.forEach((problem) => solutions.addAll(problem.solutions));

    return solutions;
  }
}
