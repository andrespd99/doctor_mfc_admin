enum AttachmentType { DOCUMENTATION, GUIDE, LINK }

class AttachmentTypeConverter {
  static const Map<String, AttachmentType> _codeToTypeMap = {
    '001': AttachmentType.DOCUMENTATION,
    '002': AttachmentType.GUIDE,
    '003': AttachmentType.LINK,
  };

  static const Map<AttachmentType, String> _typeToCodeMap = {
    AttachmentType.DOCUMENTATION: '001',
    AttachmentType.GUIDE: '002',
    AttachmentType.LINK: '003',
  };

  static AttachmentType? codeToType(String code) => _codeToTypeMap[code];
  static String? typeToCode(AttachmentType type) => _typeToCodeMap[type];
}
