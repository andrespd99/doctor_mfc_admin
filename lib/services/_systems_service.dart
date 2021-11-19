// import 'dart:async';

// import 'package:doctor_mfc_admin/models/system.dart';
// import 'package:doctor_mfc_admin/services/database.dart';

// class SystemsService {
//   final _db = Database();

//   StreamController<List<System>> _systemsListController =
//       new StreamController.broadcast();

//   Stream<List<System>> get systemsStream => _systemsListController.stream;

//   Function(List<System>) get addSystemsList => _systemsListController.sink.add;

//   Stream<List<System>> getSystemsByType(String type) {
//     _db.getSystemsByTypeSnapshots(type);
//   }

//   void dispose() {
//     _systemsListController.close();
//   }
// }
