// import 'package:doctor_mfc_admin/models/system.dart';
// import 'package:doctor_mfc_admin/models/system_type.dart';
// import 'package:doctor_mfc_admin/services/dummy_database.dart';

// class TestSystemsService {
//   // Test system types.
//   DummyDatabase _db = DummyDatabase();

//   List<SystemType> get types => _db.types;
//   List<System> get systems => _db.systems;

//   SystemType getTypeById(String id) {
//     return types.firstWhere((type) => type.id == id);
//   }

//   System getSystemById(String id) {
//     return systems.firstWhere((system) => system.id == id);
//   }

//   List<System> getSystemsByType(String typeId) {
//     List<System> result = [];

//     systems.forEach((system) {
//       if (systemIsOfType(id: typeId, system: system)) result.add(system);
//     });

//     return result;
//   }

//   bool systemIsOfType({required String id, required System system}) {
//     bool isOfType = false;
//     system.type.forEach((type) {
//       if (type.id == id) {
//         isOfType = true;
//       }
//     });
//     return isOfType;
//   }
// }
