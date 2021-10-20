class TestSystem {
  final String id;
  final String model;
  final String brand;
  final List<String> componentsIds;

  TestSystem({
    required this.id,
    required this.model,
    required this.brand,
    required this.componentsIds,
  });

  factory TestSystem.fromMap(String id, Map<String, dynamic> data) {
    return TestSystem(
      id: id,
      model: data['model'],
      brand: data['brand'],
      componentsIds: List.from(data['components']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'model': model,
        'brand': brand,
        'components': componentsIds,
      };
}
