import 'package:doctor_mfc_admin/models/step.dart';

class Solution {
  final String id;
  final String description;
  final String? instructions;
  final String? imageUrl;
  final String? guideLink;

  List<Step>? steps;

  Solution({
    required this.id,
    required this.description,
    this.instructions,
    this.steps,
    this.imageUrl,
    this.guideLink,
  });

  factory Solution.fromMap(Map<String, dynamic> data) {
    List<Step> steps = [];

    final stepsMap = List<Map<String, dynamic>>.from(data['steps'] ?? []);

    stepsMap
        .forEach((Map<String, dynamic> map) => steps.add(Step.fromMap(map)));

    return Solution(
      id: data['id'],
      description: data['description'],
      instructions: data['instructions'],
      steps: steps,
      imageUrl: data['imageUrl'],
      guideLink: data['guideLink'],
    );
  }

  Map<String, dynamic> toMap() {
    steps?.removeWhere((step) => step.description.isEmpty);

    return {
      'id': id,
      'description': description,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'guideLink': guideLink,
      'steps': steps?.map((Step step) => step.toMap()).toList(),
    };
  }

  addStep(Step step) {
    if (steps != null) {
      steps!.add(step);
    } else {
      steps = [step];
    }
  }
}
