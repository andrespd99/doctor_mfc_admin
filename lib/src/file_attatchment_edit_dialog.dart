import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/attachment.dart';
import 'package:doctor_mfc_admin/models/enums/attachment_type.dart';
import 'package:doctor_mfc_admin/services/database.dart';
import 'package:doctor_mfc_admin/services/file_picker_service.dart';
import 'package:doctor_mfc_admin/widgets/future_loading_indicator.dart';
import 'package:doctor_mfc_admin/widgets/section_header.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader_with_add_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileAttachmentEditDialog extends StatefulWidget {
  final FileAttachment attachment;
  final Function(FileAttachment) onAttachmentCallback;

  FileAttachmentEditDialog({
    required this.attachment,
    required this.onAttachmentCallback,
    Key? key,
  }) : super(key: key);

  @override
  _FileAttachmentEditDialogState createState() =>
      _FileAttachmentEditDialogState();
}

class _FileAttachmentEditDialogState extends State<FileAttachmentEditDialog> {
  late FileAttachment attachment = widget.attachment;

  bool get attachmentIsEmpty => attachment.isFileAttached;

  // File attributes
  PlatformFile? file;
  String? fileName;
  int? fileSize;

  late String attachmentTypeToStr =
      (attachment.type == AttachmentType.DOCUMENTATION)
          ? "documentation"
          : "guide";

  late String dialogTitle = isUpdating
      ? "Edit attachment"
      : "Add or select existing $attachmentTypeToStr";

  late bool isFileAttached;

  late final bool isUpdating;

  // Returns whether the attachment is valid for creation.
  // Attachment is valid if it has a title and a file OR an URL.
  bool get canFinish =>
      attachment.controller.title.text.isNotEmpty &&
      (attachment.controller.url.text.isNotEmpty || isFileAttached);

  @override
  void initState() {
    isFileAttached = attachment.isFileAttached;
    if (isFileAttached) {
      fileName = attachment.fileName;
      fileSize = attachment.fileSize;
      isUpdating = true;
    } else {
      isUpdating = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addListeners();

    return Center(
      child: Container(
        padding: EdgeInsets.all(kDefaultPadding * 3),
        constraints: BoxConstraints(
          maxWidth: 800,
          maxHeight: 600,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: '$dialogTitle'),
            SizedBox(height: kDefaultPadding),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search existing $attachmentTypeToStr',
              ),
            ),
            SizedBox(height: kDefaultPadding * 3),
            SectionSubheader('Title for $attachmentTypeToStr'),
            SizedBox(height: kDefaultPadding / 3),
            TextField(
              controller: attachment.controller.title,
              decoration: InputDecoration(
                hintText: 'Title',
              ),
            ),
            SizedBox(height: kDefaultPadding),
            // If file is attached, show header with dettach button.
            isFileAttached
                ? SectionSubheaderWithButton(
                    title: 'PDF file',
                    buttonText: 'Dettach file',
                    onPressed: () => dettachFile(),
                    buttonColor: kAccentColor,
                  )
                : SectionSubheader('PDF file'),
            SizedBox(height: kDefaultPadding / 3),
            isFileAttached
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          '${fileName!}',
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(width: kDefaultPadding / 3),
                      Text(
                        '(${fileSize! / 1000} Kbs)',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      // ! Uncomment if URL is gonna be used.
                      // Expanded(
                      //   child: TextField(
                      //     controller: attachment.controller.url,
                      //     decoration: InputDecoration(
                      //       hintText: 'URL',
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(width: kDefaultPadding / 2),
                      // Text('or'),
                      // SizedBox(width: kDefaultPadding / 3),
                      TextButton(
                        child: Text('Attach file'),
                        onPressed: () async => attachFile(),
                        style: TextButton.styleFrom(primary: Colors.grey),
                      ),
                    ],
                  ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ButtonBar(
                children: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      primary: Colors.grey,
                    ),
                  ),
                  SizedBox(width: kDefaultPadding / 2),
                  ElevatedButton(
                    child: Text(isUpdating ? 'Update' : 'Create'),
                    onPressed: canFinish ? () => onFinish() : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future attachFile() async {
    file = await FilePickerService.pickFile();
    // If file is uploaded successfully, clear URL.
    if (file != null) {
      isFileAttached = true;
      fileName = file!.name;
      fileSize = file!.size;

      attachment.controller.url.clear();
    }
    setState(() {});
  }

  void dettachFile() {
    isFileAttached = false;
    file = null;
    fileName = null;
    fileSize = null;

    setState(() {});
  }

  Future onFinish() async {
    // File was already attached, and is not being changed.
    if (isFileAttached) {
      await futureLoadingIndicator<bool?>(
              context, Database().updateAttachment(attachment, file))
          .then((success) {
        // If doc id is not null, it means that attachment was added successfully.
        if (success != null && success == true) {
          Navigator.pop(context);
          widget.onAttachmentCallback(attachment);
        }
      });
    } else {
      // File is being attached for the first time.
      assert(file != null);
      // Add attachment to database.
      await futureLoadingIndicator<bool?>(
              context, Database().addAttachment(attachment, file!))
          .then((success) {
        // If doc id is not null, it means that attachment was added successfully.
        if (success != null && success == true) {
          Navigator.pop(context);
          widget.onAttachmentCallback(attachment);
        }
      });
    }
  }

  void addListeners() {
    attachment.controller.title.addListener(() => setState(() {}));
    attachment.controller.url.addListener(() => setState(() {}));
  }
}
