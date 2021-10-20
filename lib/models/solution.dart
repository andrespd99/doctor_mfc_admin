class Solution {
  final String id;
  final String description;
  final String instructions;
  final String? imageUrl;
  final String? guideLink;

  Solution({
    required this.id,
    required this.description,
    required this.instructions,
    this.imageUrl,
    this.guideLink,
  });

  factory Solution.fromMap(
      {required String id, required Map<String, dynamic> data}) {
    return Solution(
      id: id,
      description: data['description'],
      instructions: data['instructions'],
      imageUrl: data['imageUrl'],
      guideLink: data['guideLink'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'guideLink': guideLink,
    };
  }
}
