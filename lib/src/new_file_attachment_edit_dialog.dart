import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/attachment.dart';
import 'package:doctor_mfc_admin/models/enums/attachment_type.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/services/database.dart';
import 'package:doctor_mfc_admin/services/file_picker_service.dart';
import 'package:doctor_mfc_admin/widgets/future_loading_indicator.dart';
import 'package:doctor_mfc_admin/widgets/section_header.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader.dart';
import 'package:doctor_mfc_admin/widgets/section_subheader_with_add_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class NewFileAttachmentEditDialog extends StatefulWidget {
  final Function(FileAttachment) onAttachmentCallback;
  final AttachmentType attachmentType;

  NewFileAttachmentEditDialog({
    required this.attachmentType,
    required this.onAttachmentCallback,
    Key? key,
  }) : super(key: key);

  @override
  _NewFileAttachmentEditDialogState createState() =>
      _NewFileAttachmentEditDialogState();
}

class _NewFileAttachmentEditDialogState
    extends State<NewFileAttachmentEditDialog> {
  final titleController = TextEditingController();

  String? selectedSystemId;

  // File attributes
  PlatformFile? file;
  String? get fileName => file?.name;
  int? get fileSize => file?.size;

  late String attachmentTypeToStr =
      (widget.attachmentType == AttachmentType.DOCUMENTATION)
          ? "documentation"
          : "guide";

  late String dialogTitle = "Add new $attachmentTypeToStr";

  bool get isFileAttached => file != null;

  // Returns whether the attachment is valid for creation.
  // Attachment is valid if it has system, a title and a file.
  bool get canFinish {
    if (widget.attachmentType == AttachmentType.DOCUMENTATION) {
      return titleController.text.isNotEmpty &&
          selectedSystemId != null &&
          isFileAttached;
    } else {
      return isFileAttached && titleController.text.isNotEmpty;
    }
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
            if (widget.attachmentType == AttachmentType.DOCUMENTATION)
              ...systemSelectionSection(),
            SectionSubheader('Title for $attachmentTypeToStr'),
            SizedBox(height: kDefaultPadding / 3),
            TextField(
              controller: titleController,
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
                    child: Text('Create'),
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

  List<Widget> systemSelectionSection() {
    return [
      SectionSubheader('Select a system'),
      FutureBuilder<QuerySnapshot<System>>(
        future: Database().getAllSystems(),
        builder: (context, snapshot) {
          return DropdownButton<String>(
            value: selectedSystemId,
            onChanged: (value) => setState(() => selectedSystemId = value),
            items: [
              if (!snapshot.hasData)
                DropdownMenuItem(child: Text('Loading...')),
              if (snapshot.hasData) ...dropdownSystemItems(snapshot),
            ],
          );
        },
      ),
      SizedBox(height: kDefaultPadding),
    ];
  }

  List<DropdownMenuItem<String>> dropdownSystemItems(
      AsyncSnapshot<QuerySnapshot<System>> snapshot) {
    assert(snapshot.hasData);

    return snapshot.data!.docs.map((systemSnapshot) {
      final system = systemSnapshot.data();

      return DropdownMenuItem<String>(
        value: system.id,
        child: Text(system.description),
      );
    }).toList();
  }

  Future attachFile() async {
    file = await FilePickerService.pickFile();
    // If file is uploaded successfully, clear URL.
    setState(() {});
  }

  void dettachFile() {
    file = null;

    setState(() {});
  }

  Future onFinish() async {
    assert(isFileAttached);
    assert(
      widget.attachmentType == AttachmentType.GUIDE ||
          widget.attachmentType == AttachmentType.DOCUMENTATION &&
              selectedSystemId != null,
    );

    final attachment = new FileAttachment(
      id: Uuid().v4(),
      systemId: selectedSystemId,
      title: titleController.text,
      type: widget.attachmentType,
    );
    // File is being attached for the first time.
    // Add attachment to database.
    await futureLoadingIndicator<bool?>(
            context, Database().updateAttachment(attachment, file!))
        .then((success) {
      // If doc id is not null, it means that attachment was added successfully.
      if (success != null && success == true) {
        Navigator.pop(context);
        widget.onAttachmentCallback(attachment);
      }
    });
  }

  void addListeners() {
    titleController.addListener(() => setState(() {}));
  }
}
