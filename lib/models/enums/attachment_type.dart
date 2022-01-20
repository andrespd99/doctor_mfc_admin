enum AttachmentType { DOCUMENTATION, GUIDE, LINK }

Map<String, AttachmentType> codeToTypeMap = {
  '001': AttachmentType.DOCUMENTATION,
  '002': AttachmentType.GUIDE,
  '003': AttachmentType.LINK,
};

Map<AttachmentType, String> typeToCodeMap = {
  AttachmentType.DOCUMENTATION: '001',
  AttachmentType.GUIDE: '002',
  AttachmentType.LINK: '003',
};
