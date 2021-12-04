class Step {
  String description;
  late List<String> substeps;

  Step({required this.description, substeps}) : this.substeps = substeps ?? [];

  factory Step.fromMap(Map<String, dynamic> map) {
    return Step(
      description: map['description'] as String,
      substeps: map['substeps'] as List<String>?,
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
