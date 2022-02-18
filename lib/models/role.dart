enum Role {
  USER,
  ADMIN,
  SUPER_ADMIN,
}

class RoleConverter {
  static Map<Role, String> _roleToId = {
    Role.USER: 'user',
    Role.ADMIN: 'admin',
    Role.SUPER_ADMIN: 'super_admin',
  };

  static Map<String, Role> _idToRole = {
    'user': Role.USER,
    'admin': Role.ADMIN,
    'super_admin': Role.SUPER_ADMIN,
  };

  static getRoleId(Role role) {
    return _roleToId[role];
  }

  static getRoleFromId(String id) {
    return _idToRole[id];
  }
}
