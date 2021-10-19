import 'package:doctor_mfc_admin/models/component.dart';
import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/models/system_type.dart';

class System {
  final String? id;
  final String model;
  final List<SystemType>? types;
  final String brand;
  final List<Component>? components;

  System({
    this.id,
    required this.model,
    this.types,
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
      types: List.from(data['types']),
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

  Map<String, dynamic> toMap(List componentsIds) {
    var result = {
      'description': model,
      //TODO: 'types': typesIds,
      'brand': brand,
      'components': componentsIds,
    };

    return result;
  }
}
