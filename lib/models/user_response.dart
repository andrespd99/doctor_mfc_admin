import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/models/system.dart';

class UserResponse {
  final String id;

  /// The response description. This is what the user will see when interacting
  /// with this response.
  ///
  /// Examples:
  ///
  /// "Yes", "No" (for binary questions).
  ///
  /// "Green light", "Blue light", "Red light" (multiple options questions).
  final String description;

  /// Whether this is a failing response (false) or a working response (true).
  ///
  /// A failing response should have at least one solution to solve the
  /// problem linked to this response.
  ///
  /// A working response should not have any solutions attached, as it is
  /// contradictory.
  ///
  /// The description attribute should be clear enough to distinguish easily between
  /// a failing and a working response.
  bool isOkResponse;
  final List<Solution> solutions = [];

  /// This is an auxiliary attribute to make non-editable the OK response
  /// on binary questions.
  bool get isEditable => !isOkResponse;

  UserResponse({
    required this.id,
    required this.description,
    required this.isOkResponse,
    List<Solution>? solutions,
  }) {
    if (solutions != null) this.solutions.addAll(solutions);
  }

  factory UserResponse.fromMap(Map<String, dynamic> data) {
    return UserResponse(
      id: data['id'],
      description: data['description'],
      isOkResponse: data['isOkResponse'],
      solutions: _getSolutions(List.from(data['solutions'] ?? [])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'isOkResponse': isOkResponse,
      'solutions': _solutionsToMap(),
    };
  }

  Map<String, dynamic> searchResultToMap({
    required Problem problem,
    required System system,
  }) {
    return {
      'entityTypeId': '003',
      'problemId': problem.id,
      'problemDescription': problem.description,
      'systemId': system.id,
      'systemDescription': system.description,
      'systemBrand': system.brand,
      'sypmton': (problem.isMultiOptions == true) ? this.description : null,
      'solutions': _solutionsToMap(),
    };
  }

  /// Converts the List of [Solution]s to a json map.
  List<Map<String, dynamic>>? _solutionsToMap() =>
      solutions.map((solution) => solution.toMap()).toList();

  /// Returns a List of [Solution] from a json map.
  static List<Solution> _getSolutions(List<Map<String, dynamic>>? data) {
    if (data != null)
      return data
          .map((solutionData) => Solution.fromMap(solutionData))
          .toList();
    else
      return [];
  }
}
