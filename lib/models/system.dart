import 'package:doctor_mfc_admin/models/component.dart';
import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/models/system_type.dart';
import 'package:doctor_mfc_admin/models/user_response.dart';

class System {
  final String? id;
  final String model;
  final String type;
  final String brand;
  final List<Component>? components;

  System({
    this.id,
    required this.model,
    required this.type,
    required this.brand,
    this.components,
  });

  factory System.fromMap({
    required String id,
    required Map<String, dynamic> data,
    List<Component>? components,
  }) {
    return System(
      id: id,
      model: data['description'],
      type: data['type'],
      brand: data['brand'],
      components: components,
    );
  }

  /// Returns the amount of known problems this component has.
  int knownProblemsCount() {
    int counter = 0;
    components?.forEach((component) {
      component.problems?.forEach((problem) => counter++);
    });
    return counter;
  }

  /// Returns the amount of solutions this component has.
  int solutionsCount() {
    int counter = 0;

    components?.forEach((component) {
      component.problems?.forEach((problem) {
        problem.userResponses?.forEach((response) {
          response.solutions?.forEach((solution) => counter++);
        });
      });
    });

    return counter;
  }

  Map<String, dynamic> toMap() {
    return {
      'description': model,
      'type': type,
      'brand': brand,
      'components': componentsIds ?? [] as List<String>,
    };
  }

/* --------------------------------- Getters -------------------------------- */

  List<String>? get componentsIds =>
      components?.map((component) => component.id).toList();

  List<Problem> get knownProblems {
    List<Problem> knownProblems = [];
    components?.forEach(
        (component) => knownProblems.addAll(component.problems ?? []));
    return knownProblems;
  }

  List<UserResponse> get userResponses {
    List<UserResponse> userResponses = [];
    knownProblems.forEach(
        (problem) => userResponses.addAll(problem.userResponses ?? []));
    return userResponses;
  }

  List<Solution> get solutions {
    List<Solution> solutions = [];
    userResponses
        .forEach((response) => solutions.addAll(response.solutions ?? []));
    return solutions;
  }
}
