import 'dart:async';

import 'package:doctor_mfc_admin/models/test/test_system.dart';
import 'package:doctor_mfc_admin/services/database.dart';

class NewSystemsService {
  Database _db = Database();

  StreamController<List<TestSystem>> _systemsController =
      StreamController.broadcast();

  Stream<List<TestSystem>> get systemsStream => _systemsController.stream;

  Function(List<TestSystem>) get addSystem => _systemsController.sink.add;
}
