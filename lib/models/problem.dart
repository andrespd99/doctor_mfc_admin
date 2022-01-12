import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/models/user_response.dart';

class Problem {
  final String id;
  final String description;
  final String question;
  final List<String> keywords;
  final List<UserResponse> userResponses;
  final bool isMultiOptions;

  Problem({
    required this.id,
    required this.description,
    required this.question,
    required this.keywords,
    required this.userResponses,
    required this.isMultiOptions,
  });

  factory Problem.fromMap(Map<String, dynamic> data) {
    return Problem(
      id: data['id'],
      description: data['description'],
      question: data['question'],
      keywords: List.from(data['keywords']),
      userResponses: _getResponses(List.from(data['userResponses'] ?? [])),
      isMultiOptions: data['isMultiOptions'],
    );
  }

  Map<String, dynamic> toMap([System? system]) {
    final map = {
      'id': id,
      'description': description,
      'question': question,
      'keywords': keywords,
      'userResponses': _responsesToMap(),
      'isMultiOptions': isMultiOptions,
    };

    // If systemId is provided, add it to the map.
    if (system != null)
      map.addAll({
        'systemId': system.id,
        'systemDescription': system.description,
        'systemBrand': system.brand,
      });

    return map;
  }

  Map<String, dynamic> searchResultToMap(System system) {
    return {
      'entityTypeId': '002',
      ...this.toMap(system),
    };
  }

  /// Converts the List of [UserResponse]s to a json map.
  List<Map<String, dynamic>> _responsesToMap() =>
      userResponses.map((response) => response.toMap()).toList();

  /// Returns a List of [UserResponse] from a json map.
  static List<UserResponse> _getResponses(List<Map<String, dynamic>>? data) {
    if (data != null)
      return data
          .map((responseData) => UserResponse.fromMap(responseData))
          .toList();
    else
      return [];
  }

  /// Returns the amount of failure options (user responses with solutions associated)
  /// linked to this problem.
  int get failureOptionsCount {
    int counter = 0;
    userResponses.forEach((response) {
      if (!response.isOkResponse) counter++;
    });
    return counter;
  }

  /// Returns all solutions linked to this problem.
  List<Solution> get solutions {
    List<Solution> solutions = [];

    userResponses.forEach((response) {
      solutions.addAll(response.solutions);
    });

    return solutions;
  }
}
