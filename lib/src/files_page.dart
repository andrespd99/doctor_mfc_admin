import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/attachment.dart';
import 'package:doctor_mfc_admin/models/enums/attachment_type.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/services/database.dart';
import 'package:doctor_mfc_admin/src/file_attatchment_edit_dialog.dart';
import 'package:doctor_mfc_admin/src/new_file_attachment_edit_dialog.dart';
import 'package:doctor_mfc_admin/widgets/body_template.dart';
import 'package:doctor_mfc_admin/widgets/custom_card.dart';
import 'package:doctor_mfc_admin/widgets/custom_loading_indicator.dart';
import 'package:doctor_mfc_admin/widgets/green_elevated_button.dart';
import 'package:flutter/material.dart';

class FilesPage extends StatefulWidget {
  final AttachmentType type;
  FilesPage({required this.type, Key? key}) : super(key: key);

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  bool get isDocumentationType => widget.type == AttachmentType.DOCUMENTATION;

  late String title = isDocumentationType ? 'Documentation' : 'How-to guides';

  @override
  Widget build(BuildContext context) {
    final database = Database();
    return BodyTemplate(
      title: '$title',
      body: [
        addFileButton(),
        // TODO: Add searcher.
        // Row(
        //   children: [
        //     Container(
        //       width: MediaQuery.of(context).size.width * 0.3,
        //       child: TextField(
        //         decoration: InputDecoration(
        //           hintText: 'Search for a file',
        //         ),
        //       ),
        //     ),
        //     SizedBox(width: kDefaultPadding / 2),
        //   ],
        // ),
        SizedBox(height: kDefaultPadding),
        StreamBuilder<QuerySnapshot<FileAttachment>>(
          stream: isDocumentationType
              ? database.getAllDocumentation()
              : database.getAllGuides(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final files = snapshot.data!.docs;

              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: files.length,
                itemBuilder: (_, i) {
                  final file = files[i].data();

                  return CustomCard(
                    title: file.title,
                    body: [
                      Text(file.fileName!),
                      if (isDocumentationType) ...documentationCardBody(file)
                    ],
                    onPressed: () => openFileDetails(file),
                  );
                },
                separatorBuilder: (_, i) =>
                    SizedBox(height: kDefaultPadding / 2),
              );
            } else {
              return CustomLoadingIndicator();
            }
          },
        ),
      ],
    );
  }

  List<Widget> documentationCardBody(FileAttachment document) {
    return [
      SizedBox(height: kDefaultPadding / 2),
      Container(
        height: 18.0,
        child: StreamBuilder<DocumentSnapshot<System?>>(
          stream: Database().getSystemSnapshotById(document.systemId!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              System system = snapshot.data!.data()!;
              return Text(
                '${system.brand} ${system.description}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    ];
  }

  GreenElevatedButton addFileButton() {
    return GreenElevatedButton(
      child: Text(isDocumentationType ? 'Add documentation' : 'Add guide'),
      onPressed: () => onAddPressed(),
    );
  }

  void onAddPressed() => showDialog(
        context: context,
        builder: (context) {
          return NewFileAttachmentEditDialog(
            attachmentType: widget.type,
            onAttachmentCallback: (attachmentUpdated) =>
                onAttachmentCallback(attachmentUpdated),
          );
        },
      );

  void openFileDetails(FileAttachment document) {
    showDialog(
      context: context,
      builder: (context) {
        return FileAttachmentEditDialog(
          attachment: document,
          onAttachmentCallback: (attachmentUpdated) =>
              onAttachmentCallback(attachmentUpdated),
        );
      },
    );
  }

  void onAttachmentCallback(FileAttachment attachment) {
    setState(() {});
  }
}
