import 'package:doctor_mfc_admin/models/solution.dart';

class UserResponse {
  final String id;
  final String description;
  final bool isOkResponse;
  final List<Solution>? solutions;

  UserResponse({
    required this.id,
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

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'isOkResponse': isOkResponse,
      'solutions': solutionsIds ?? [] as List<String>,
    };
  }

  List<String>? get solutionsIds =>
      solutions?.map((solution) => solution.id).toList();
}
