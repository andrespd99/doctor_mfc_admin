class SystemType {
  final String id;
  final String description;
  final String pluralDescription;

  SystemType({
    required this.id,
    required this.description,
    required this.pluralDescription,
  });

  factory SystemType.fromMap({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return SystemType(
      id: id,
      description: data['description'],
      pluralDescription: data['pluralDescription'],
    );
  }
}
