import 'package:doctor_mfc_admin/models/enums/attachment_type.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AttachmentController {
  TextEditingController title;
  TextEditingController url;

  AttachmentController({
    String? title = '',
    String? url = '',
  })  : title = TextEditingController(text: title),
        url = TextEditingController(text: url);

  void clearFields() {
    title.clear();
    url.clear();
  }
}

abstract class Attachment {
  AttachmentType type;
  String get title => controller.title.text;

  AttachmentController controller;

  Attachment({
    required this.type,
    String? title,
    String? url,
  }) : controller = AttachmentController(title: title, url: url);

  factory Attachment.fromMap(Map<String, dynamic> data) {
    if (codeToTypeMap[data['type']] == AttachmentType.LINK) {
      return LinkAttachment(
        title: data['title'],
        url: data['url'],
      );
    } else {
      return FileAttachment.fromMap(data['id'], data);
    }
  }
}

class FileAttachment extends Attachment {
  String id;
  String? fileName;
  int? fileSize;

  String? systemId;

  String? fileUrl;

  bool get isFileAttached => (fileSize != null && fileName != null);

  FileAttachment({
    required AttachmentType type,
    String? id,
    String? title,
    this.systemId,
    this.fileUrl,
    this.fileName,
    this.fileSize,
  })  : this.id = id ?? Uuid().v4(),
        assert((type == AttachmentType.DOCUMENTATION && systemId != null) ||
            type != AttachmentType.DOCUMENTATION),
        super(
          title: title,
          type: type,
        );

  factory FileAttachment.fromMap(String id, Map<String, dynamic> data) {
    return FileAttachment(
      id: id,
      systemId: data['systemId'],
      type: codeToTypeMap[data['type'] as String]!,
      title: data['title'],
      fileUrl: data['fileUrl'],
      fileName: data['fileName'],
      fileSize: data['fileSize'],
    );
  }

  Map<String, dynamic> toMap() {
    assert(fileUrl != null);
    assert(fileName != null);
    assert(title.isNotEmpty);
    assert(type != AttachmentType.DOCUMENTATION ||
        type == AttachmentType.DOCUMENTATION && systemId != null);

    return {
      'id': id,
      if (type == AttachmentType.DOCUMENTATION) 'systemId': systemId,
      'type': typeToCodeMap[type],
      'title': title,
      'fileName': fileName,
      'fileSize': fileSize,
      'fileUrl': fileUrl,
    };
  }

  void setFileData(PlatformFile file, String fileUrl) {
    fileName = file.name;
    fileSize = file.size;
    fileUrl = fileUrl;
  }

  void dettachFile() {
    fileName = null;
    fileSize = null;
    fileUrl = null;
  }
}

class LinkAttachment extends Attachment {
  String get url => controller.url.text;

  LinkAttachment({
    String? title,
    String? url,
  }) : super(
          title: title,
          url: url,
          type: AttachmentType.LINK,
        );

  Map<String, dynamic> toMap() {
    assert(title.isNotEmpty);
    assert(url.isNotEmpty);

    return {
      'title': title,
      'url': url,
      'type': typeToCodeMap[type],
    };
  }
}
