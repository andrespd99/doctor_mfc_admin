import 'package:doctor_mfc_admin/models/attachment.dart';
import 'package:doctor_mfc_admin/models/step.dart';

class Solution {
  final String id;
  final String description;
  final String? instructions;
  // final String? imageUrl;
  final List<Attachment>? attachments;

  List<Step>? steps;

  Solution({
    required this.id,
    required this.description,
    this.instructions,
    this.steps,
    this.attachments,
    // this.imageUrl,
  });

  factory Solution.fromMap(Map<String, dynamic> data) {
    return Solution(
      id: data['id'],
      description: data['description'],
      instructions: data['instructions'],
      steps: _getStepsFromMap(List.from(data['steps'] ?? [])),
      attachments: _getAttachmentsFromMap(List.from(data['attachments'] ?? [])),
      // imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    steps?.removeWhere((step) => step.description.isEmpty);

    return {
      'id': id,
      'description': description,
      if (instructions != null && instructions!.isNotEmpty)
        'instructions': instructions,
      if (steps != null && steps!.isNotEmpty)
        'steps': steps!.map((step) => step.toMap()).toList(),
      if (attachments != null && attachments!.isNotEmpty)
        'attachments': attachments!.map((attachment) {
          if (attachment is FileAttachment) {
            return attachment.toMap();
          } else if (attachment is LinkAttachment) {
            return attachment.toMap();
          }
        }).toList(),
      // 'imageUrl': imageUrl,
    };
  }

  /// Returns a List of [Step] from a json map.
  static List<Step>? _getStepsFromMap(List<Map<String, dynamic>>? data) {
    if (data != null || data!.length != 0)
      return data.map((stepsData) => Step.fromMap(stepsData)).toList();
  }

  void addStep(Step step) {
    if (steps != null) {
      steps!.add(step);
    } else {
      steps = [step];
    }
  }

  static List<Attachment>? _getAttachmentsFromMap(
      List<Map<String, dynamic>> attachments) {
    if (attachments.isNotEmpty)
      return attachments
          .map((attachmentMap) => Attachment.fromMap(attachmentMap))
          .toList();
  }
}
