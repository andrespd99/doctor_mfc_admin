import 'package:doctor_mfc_admin/models/problem.dart';

class Component {
  final String id;
  final String description;
  final List<Problem>? problems;

  Component({
    required this.id,
    required this.description,
    this.problems,
  });

  factory Component.fromMap({
    required String id,
    required Map<String, dynamic> data,
    List<Problem>? problems,
  }) {
    return Component(
      id: id,
      description: data['description'],
      problems: problems,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'problems': problemsIds ?? [] as List<String>,
    };
  }

  List<String>? get problemsIds =>
      problems?.map((problem) => problem.id).toList();
}
