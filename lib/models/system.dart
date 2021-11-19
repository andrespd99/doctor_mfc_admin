import 'package:doctor_mfc_admin/models/component.dart';
import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/solution.dart';

import 'package:doctor_mfc_admin/models/user_response.dart';

class System {
  final String id;
  final String model;
  final String type;
  final String brand;
  final List<Component> components;

  System({
    required this.id,
    required this.model,
    required this.type,
    required this.brand,
    required this.components,
  });

  factory System.fromMap({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return System(
      id: id,
      model: data['description'],
      type: data['type'],
      brand: data['brand'],
      components: _getComponents(List.from(data['components'] ?? [])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': model,
      'type': type,
      'brand': brand,
      'components': _componentsToMap(),
    };
  }

  /// Returns the amount of known problems this component has.
  int knownProblemsCount() {
    int counter = 0;
    components.forEach((component) {
      component.problems?.forEach((problem) => counter++);
    });
    return counter;
  }

  /// Returns the amount of solutions this component has.
  int solutionsCount() {
    int counter = 0;

    components.forEach((component) {
      component.problems.forEach((problem) {
        problem.userResponses.forEach((response) {
          response.solutions?.forEach((solution) => counter++);
        });
      });
    });

    return counter;
  }

  /// Converts a List of [Component]s to a json map.
  List<Map<String, dynamic>> _componentsToMap() {
    return components.map((component) => component.toMap()).toList();
  }

  /// Converts a json map to a List of [Component]s.
  static List<Component> _getComponents(List<Map<String, dynamic>>? data) {
    if (data != null)
      return data
          .map((componentData) => Component.fromMap(componentData))
          .toList();
    else
      return [];
  }

/* --------------------------------- Getters -------------------------------- */

  List<Problem> get knownProblems {
    List<Problem> knownProblems = [];

    components.forEach((component) => knownProblems.addAll(component.problems));

    return knownProblems;
  }

  List<UserResponse> get userResponses {
    List<UserResponse> userResponses = [];

    knownProblems
        .forEach((problem) => userResponses.addAll(problem.userResponses));

    return userResponses;
  }

  List<Solution> get solutions {
    List<Solution> solutions = [];

    userResponses
        .forEach((response) => solutions.addAll(response.solutions ?? []));

    return solutions;
  }
}
