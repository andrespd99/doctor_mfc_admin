import 'package:doctor_mfc_admin/models/enums/attachment_type.dart';

enum SearchType { ISSUE, DOCUMENTATION, GUIDE }

class SearchTypeConverter {
  static const Map<String, SearchType> _codeToTypeMap = {
    '001': SearchType.ISSUE,
    '002': SearchType.DOCUMENTATION,
    '003': SearchType.GUIDE,
  };

  static const Map<SearchType, String> _typeToCodeMap = {
    SearchType.ISSUE: '001',
    SearchType.DOCUMENTATION: '002',
    SearchType.GUIDE: '003',
  };

  static const Map<AttachmentType, String> _attachmentTypeToCodeMap = {
    AttachmentType.DOCUMENTATION: '002',
    AttachmentType.GUIDE: '003',
  };

  static SearchType? codeToSearchType(String code) => _codeToTypeMap[code];
  static String? searchTypeToCode(SearchType type) => _typeToCodeMap[type];
  static String? attachmentTypeToSearchCode(AttachmentType type) =>
      _attachmentTypeToCodeMap[type];
}
