import 'package:doctor_mfc_admin/models/guide_link.dart';
import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/step.dart';
import 'package:doctor_mfc_admin/models/system.dart';

class Solution {
  final String id;
  final String description;
  final String? instructions;
  final String? imageUrl;
  final List<GuideLink>? links;

  List<Step>? steps;

  Solution({
    required this.id,
    required this.description,
    this.instructions,
    this.steps,
    this.imageUrl,
    this.links,
  });

  factory Solution.fromMap(Map<String, dynamic> data) {
    return Solution(
      id: data['id'],
      description: data['description'],
      instructions: data['instructions'],
      imageUrl: data['imageUrl'],
      links: _getLinksFromMap(List.from(data['links'] ?? [])),
      steps: _getStepsFromMap(List.from(data['steps'] ?? [])),
    );
  }

  Map<String, dynamic> toMap() {
    steps?.removeWhere((step) => step.description.isEmpty);

    return {
      'id': id,
      'description': description,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'links': links?.map((link) => link.toMap()).toList(),
      'steps': steps?.map((step) => step.toMap()).toList(),
    };
  }

  /// Returns a List of [Step] from a json map.
  static List<Step> _getStepsFromMap(List<Map<String, dynamic>>? data) {
    if (data != null)
      return data.map((stepsData) => Step.fromMap(stepsData)).toList();
    else
      return [];
  }

  /// Returns a List of [GuideLink] from a json map.
  static List<GuideLink> _getLinksFromMap(List<Map<String, dynamic>>? data) {
    if (data != null)
      return data.map((linkData) => GuideLink.fromMap(linkData)).toList();
    else
      return [];
  }

  addStep(Step step) {
    if (steps != null) {
      steps!.add(step);
    } else {
      steps = [step];
    }
  }
}
