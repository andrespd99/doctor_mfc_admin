import 'package:doctor_mfc_admin/models/role.dart';

class AppUser {
  String id;
  String userName;
  String userEmail;
  Role role;
  bool? disabled;

  AppUser({
    required this.id,
    required this.userName,
    required this.userEmail,
    required this.role,
    this.disabled,
  });

  factory AppUser.fromMap({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return AppUser(
      id: id,
      userName: data['userName'],
      userEmail: data['userEmail'],
      role: RoleConverter.getRoleFromId(data['role']),
      disabled: data['disabled'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'role': RoleConverter.getRoleId(role),
      'disabled': (disabled != null) ? disabled : false,
    };
  }
}
