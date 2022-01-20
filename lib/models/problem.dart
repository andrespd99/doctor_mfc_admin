import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/models/system.dart';

class Problem {
  final String id;
  final String description;
  final List<String> keywords;
  final List<Solution> solutions;

  //* Pre v3.0.0: OLD ATTRIBUTES
  // final String question;
  // final List<UserResponse> userResponses;
  // final bool isMultiOptions;

  Problem({
    required this.id,
    required this.description,
    required this.keywords,
    required this.solutions,

    //* Pre v3.0.0: OLD PARAMS
    // required this.question,
    // required this.userResponses,
    // required this.isMultiOptions,
  });

  factory Problem.fromMap(Map<String, dynamic> data) {
    return Problem(
      id: data['id'],
      description: data['description'],
      keywords: List.from(data['keywords']),
      solutions: (data['solutions'] as List<dynamic>)
          .map((e) => Solution.fromMap(e))
          .toList(),

      //* Pre v3.0.0: OLD PARAMS
      // question: data['question'],
      // userResponses: _getResponses(List.from(data['userResponses'] ?? [])),
      // isMultiOptions: data['isMultiOptions'],
    );
  }

  Map<String, dynamic> toMap([System? system]) {
    final map = {
      'id': id,
      'description': description,
      'keywords': keywords,
      'solutions': solutions.map((e) => e.toMap()).toList(),

      //* Pre v3.0.0: OLD PARAMS
      // 'question': question,
      // 'userResponses': _responsesToMap(),
      // 'isMultiOptions': isMultiOptions,
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
      'entityTypeId': '001',
      'systemId': system.id,
      'systemDescription': system.description,
      'systemBrand': system.brand,
      ...this.toMap(system),
    };
  }
}
