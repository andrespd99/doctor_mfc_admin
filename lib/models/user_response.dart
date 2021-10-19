import 'package:doctor_mfc_admin/models/solution.dart';

class UserResponse {
  final String? id;
  final String description;
  final bool isOkResponse;
  final List<Solution>? solutions;

  UserResponse({
    this.id,
    required this.description,
    required this.isOkResponse,
    this.solutions,
  });

  factory UserResponse.fromMap({
    required String id,
    required Map<String, dynamic> data,
    List<Solution>? solutions,
  }) {
    return UserResponse(
      id: id,
      description: data['description'],
      isOkResponse: data['isOkResponse'],
      solutions: solutions,
    );
  }

  Map<String, dynamic> toMap(List<String> solutionsIds) {
    return {
      'description': description,
      'isOkResponse': isOkResponse,
      'solutions': solutionsIds,
    };
  }
}
