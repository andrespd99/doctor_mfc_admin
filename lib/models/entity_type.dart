/// Enum for entity types, which can be either system, problem, solution,
/// documentation or guides.
enum EntityType {
  SYSTEM,
  PROBLEM,
  SOLUTION,
  DOCUMENTATION,
  GUIDE,
}

class EntityTypeConverter {
  static typeToString(EntityType type) {
    switch (type) {
      case EntityType.SYSTEM:
        return 'system';
      case EntityType.PROBLEM:
        return 'problem';
      case EntityType.SOLUTION:
        return 'solution';
      case EntityType.DOCUMENTATION:
        return 'documentation';
      case EntityType.GUIDE:
        return 'guide';
      default:
        return 'unknown';
    }
  }

  static stringToType(String type) {
    switch (type.toLowerCase()) {
      case 'system':
        return EntityType.SYSTEM;
      case 'problem':
        return EntityType.PROBLEM;
      case 'solution':
        return EntityType.SOLUTION;
      case 'documentation':
        return EntityType.DOCUMENTATION;
      case 'guide':
        return EntityType.GUIDE;
      default:
        throw new Exception('Unknown entity type: $type');
    }
  }
}
