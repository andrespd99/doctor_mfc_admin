import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalValues {
  final _db = FirebaseFirestore.instance;

  Future<List<String>> getSystemTypes() async {
    List<String> systemTypes = [];

    await _db
        .collection('globalVariables')
        .doc('systemTypes')
        .get()
        .then((doc) {
      systemTypes = List.from(doc['systemTypes']);
    });

    return systemTypes;
  }

  Future<List<String>> getBrands() async {
    List<String> brands = [];

    _db.collection('globalVariables').doc('brands').get().then((doc) {
      brands = List.from(doc['brands']);
    });

    return brands;
  }

  Future<Map<String, List<String>>> getGlobalValues() async {
    final systemTypes = await getSystemTypes();
    final brands = await getBrands();

    return {
      'systemTypes': systemTypes,
      'brands': brands,
    };
  }
}

//   List<String> systemTypes = [];
//   List<String> brands = [];

// /* ------------------------------- Controllers ------------------------------ */
//   StreamController<List<String>> _systemTypesController =
//       new StreamController<List<String>>();
//   StreamController<List<String>> _brandsController =
//       new StreamController<List<String>>();

//   Stream get systemTypesStream => _systemTypesController.stream;
//   Stream get brandsStream => _brandsController.stream;

//   Function(List<String>) get updateSystemTypes =>
//       _systemTypesController.sink.add;
//   Function(List<String>) get updateBrands => _brandsController.sink.add;
