import 'package:doctor_mfc_admin/widgets/future_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/services/database.dart';

import 'package:doctor_mfc_admin/models/entity_type.dart';
import 'package:doctor_mfc_admin/models/request_type.dart';
import 'package:doctor_mfc_admin/models/user_request.dart';
import 'package:doctor_mfc_admin/widgets/body_template.dart';
import 'package:doctor_mfc_admin/src/request_details_dialog.dart';
import 'package:doctor_mfc_admin/widgets/custom_loading_indicator.dart';

class UserRequestsPage extends StatefulWidget {
  UserRequestsPage({Key? key}) : super(key: key);

  @override
  State<UserRequestsPage> createState() => _UserRequestsPageState();
}

class _UserRequestsPageState extends State<UserRequestsPage> {
  bool showUnreviewed = true;

  Future<QuerySnapshot<UserRequest>> _future =
      Database().getUnreviewedUserRequests();

  @override
  Widget build(BuildContext context) {
    return BodyTemplate(
      title: 'User requests',
      body: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            child: Text(
              (showUnreviewed)
                  ? 'View requests history'
                  : 'View pending requests',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              setState(() {
                showUnreviewed = !showUnreviewed;
                _future = (showUnreviewed)
                    ? Database().getUnreviewedUserRequests()
                    : Database().getReviewedUserRequests();
              });
            },
          ),
        ),
        SizedBox(height: kDefaultPadding),
        FutureBuilder<QuerySnapshot<UserRequest>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomLoadingIndicator());
            } else if (snapshot.hasData) {
              List<UserRequest> requests =
                  snapshot.data!.docs.map((e) => e.data()).toList();

              if (requests.isEmpty) {
                return Center(
                  child: Text(
                    'No requests',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18.0,
                    ),
                  ),
                );
              } else
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: requests.length,
                  itemBuilder: (context, i) {
                    return requestCard(requests[i]);
                  },
                  separatorBuilder: (context, i) =>
                      SizedBox(height: kDefaultPadding),
                );
            } else {
              return Center(
                child: Text(
                  'No user requests',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget requestCard(UserRequest request) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        color: Colors.black.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Request to ', style: TextStyle(color: kPrimaryColor)),
                    Text(
                      '${RequestTypeConverter.typeToString(request.requestType)} ',
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${EntityTypeConverter.typeToString(request.entityType)}',
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: kDefaultPadding / 2),
                if (request.systemNameToAdd != null)
                  ...newSystemSection(request),
                if (request.systemToUpdate != null)
                  ...updateSystemDescription(request),
                if (request.problemToUpdate != null)
                  problemDescription(request),
                if (request.solutionToUpdate != null)
                  solutionDescription(request),
                SizedBox(height: kDefaultPadding / 2),
                requesterSection(request),
              ],
            ),
          ),
          IconButton(
            onPressed: () => openRequest(request),
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows the details of the person that made this request.
  Widget requesterSection(UserRequest request) {
    return Row(
      children: [
        Text('Requester:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(' ${request.userEmail}'),
      ],
    );
  }

  List<Widget> updateSystemDescription(UserRequest request) {
    return [
      SizedBox(height: kDefaultPadding / 3),
      Row(
        children: [
          Text('System:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(' ${request.systemToUpdate}'),
        ],
      ),
    ];
  }

  Widget problemDescription(UserRequest request) {
    return Row(
      children: [
        Text('Problem:', style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(
            ' ${request.problemToUpdate}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget solutionDescription(UserRequest request) {
    return Row(
      children: [
        Text('Solution:', style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
            child: Text(
          ' ${request.solutionToUpdate}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
      ],
    );
  }

  /// Shows the details of the system requested to be added.
  List<Widget> newSystemSection(UserRequest request) {
    return [
      Row(
        children: [
          Text('System model:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(' ${request.systemNameToAdd}'),
        ],
      ),
      Row(
        children: [
          Text('Brand:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(' ${request.systemBrandToAdd ?? 'N/A'}'),
        ],
      ),
    ];
  }

  void openRequest(UserRequest request) {
    showDialog(
      context: context,
      builder: (context) => RequestDetailsDialog(
        request: request,
        onRequestReviewed: () {
          futureLoadingIndicator(
            context,
            Database().setRequestAsReviewed(request),
          ).then((value) => Navigator.pop(context));
          setState(() {});
        },
      ),
    );
  }
}
