class Step {
  String description;
  List<String> substeps;

  Step({required this.description, List<String>? substeps})
      : this.substeps = substeps ?? [];

  factory Step.fromMap(Map<String, dynamic> map) {
    return Step(
      description: map['description'] as String,
      substeps: List<String>.from(map['substeps'] ?? []),
    );
  }

  addSubstep(String substep) => substeps.add(substep);

  Map<String, dynamic> toMap() {
    substeps.removeWhere((substep) => substep.isEmpty);

    return <String, dynamic>{
      'description': description,
      'substeps': substeps,
    };
  }
}
