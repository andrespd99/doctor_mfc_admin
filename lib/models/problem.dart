import 'package:doctor_mfc_admin/models/user_response.dart';

class Problem {
  final String id;
  final String description;
  final String question;
  final List<String> keywords;
  final List<UserResponse> userResponses;
  // final Object guidance;

  Problem({
    required this.id,
    required this.description,
    required this.question,
    required this.keywords,
    required this.userResponses,
  });

  factory Problem.fromMap(Map<String, dynamic> data) {
    return Problem(
      id: data['id'],
      description: data['description'],
      question: data['question'],
      keywords: List.from(data['keywords']),
      userResponses: _getResponses(List.from(data['userResponses'] ?? [])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'question': question,
      'keywords': keywords,
      'userResponses': _responsesToMap(),
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
}
