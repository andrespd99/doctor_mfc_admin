import 'package:doctor_mfc_admin/models/system.dart';

class CurrentSystemSelectedService {
  System? _system;

  CurrentSystemSelectedService({System? system}) : _system = system;

  System? get currentSelectedSystem => _system;

  void selectSystem(System system) {
    _system = system;
  }
}
