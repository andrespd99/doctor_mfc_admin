import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/user_request.dart';
import 'package:doctor_mfc_admin/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class RequestDetailsDialog extends StatefulWidget {
  final UserRequest request;
  final Function() onRequestReviewed;
  RequestDetailsDialog({
    required this.request,
    required this.onRequestReviewed,
    Key? key,
  }) : super(key: key);

  @override
  State<RequestDetailsDialog> createState() => _RequestDetailsDialogState();
}

class _RequestDetailsDialogState extends State<RequestDetailsDialog> {
  late final UserRequest request = widget.request;
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      showBackButton: false,
      title: 'Request details',
      body: [
        if (request.reviewed) ...[
          Container(
            padding: EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
              border: Border.all(color: kSecondaryColor, width: 1),
              color: kSecondaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            ),
            child: Center(
              child: Text(
                'Request reviewed',
                style: TextStyle(
                  color: kSecondaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: kDefaultPadding),
        ],
        Row(
          children: [
            Text(
              'Requester: ',
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
            ),
            Text(
              '${request.userEmail}',
              style: TextStyle(color: kPrimaryColor),
            ),
          ],
        ),
        SizedBox(height: kDefaultPadding),
        if (request.systemNameToAdd != null) ...[
          sectionTitle('Requested system details'),
          SizedBox(height: kDefaultPadding / 3),
          Text('${request.systemNameToAdd} ${request.systemBrandToAdd ?? ''}'),
        ],
        if (request.systemToUpdate != null) ...[
          sectionTitle('System'),
          SizedBox(height: kDefaultPadding / 3),
          Text('${request.systemToUpdate}'),
        ],
        if (request.problemToUpdate != null) ...[
          SizedBox(height: kDefaultPadding),
          sectionTitle('Problem'),
          SizedBox(height: kDefaultPadding / 3),
          Expanded(child: Text('${request.problemToUpdate}')),
        ],
        if (request.solutionToUpdate != null) ...[
          SizedBox(height: kDefaultPadding),
          sectionTitle('Solution'),
          SizedBox(height: kDefaultPadding / 3),
          Expanded(child: Text('${request.solutionToUpdate}')),
        ],
        SizedBox(height: kDefaultPadding * 2),
        Text(
          'Ticket details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: kDefaultPadding),
        Expanded(child: sectionTitle('${request.requestTitle}')),
        SizedBox(height: kDefaultPadding / 3),
        Expanded(child: Text('${request.requestDescription}')),
      ],
      finishButtonTitle: 'Mark as reviewed',
      onFinish: (!request.reviewed) ? () => widget.onRequestReviewed() : null,
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
