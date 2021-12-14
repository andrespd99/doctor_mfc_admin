class Step {
  String description;
  List<String> substeps;

  Step({required this.description, List<String>? substeps})
      : this.substeps = substeps ?? [];

  factory Step.fromMap(Map<String, dynamic> data) {
    return Step(
      description: data['description'] as String,
      substeps: List<String>.from(data['substeps'] ?? []),
    );
  }

  addSubstep(String substep) => substeps.add(substep);

  Map<String, dynamic> toMap() {
    substeps.removeWhere((substep) => substep.isEmpty);

    return {
      'description': description,
      'substeps': substeps,
    };
  }
}
