import 'package:doctor_mfc_admin/models/user_response.dart';

class Problem {
  final String? id;
  final String description;
  final String question;
  final List<String> keywords;
  final List<UserResponse>? userResponses;
  // final Object guidance;

  Problem({
    this.id,
    required this.description,
    required this.question,
    required this.keywords,
    this.userResponses,
  });

  factory Problem.fromMap({
    required String id,
    required Map<String, dynamic> data,
    List<UserResponse>? userResponses,
  }) {
    return Problem(
      id: id,
      description: data['description'],
      question: data['question'],
      keywords: List.from(data['keywords']),
      userResponses: userResponses,
    );
  }

  Map<String, dynamic> toMap(List<String> responsesIds) {
    return {
      'description': description,
      'question': question,
      'keywords': keywords,
      'userResponses': responsesIds,
    };
  }
}
