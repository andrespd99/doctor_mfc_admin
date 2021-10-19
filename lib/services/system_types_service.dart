import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/models/system_type.dart';

class SystemTypesService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  late List<String> types = [];

  SystemTypesService() {
    fetchTypes();
  }

  Future<void> fetchTypes() async {
    await _db.collection('types').get().then((querySnap) {
      querySnap.docs.forEach((docSnap) {
        types.add(docSnap.id);
      });
    });
  }
}
