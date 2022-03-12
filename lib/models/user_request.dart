import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/models/entity_type.dart';
import 'package:doctor_mfc_admin/models/request_type.dart';

class UserRequest {
  String id;
  String userId;
  String userEmail;
  String? reviewerEmail;
  Timestamp timestamp;

  RequestType requestType;
  EntityType entityType;
  String? systemNameToAdd;
  String? systemBrandToAdd;

  String? systemToUpdate;
  String? problemToUpdate;
  String? solutionToUpdate;

  String requestTitle;
  String requestDescription;

  bool reviewed;

  UserRequest({
    required this.id,
    required this.requestType,
    required this.entityType,
    required this.requestTitle,
    required this.requestDescription,
    required this.userId,
    required this.userEmail,
    required this.timestamp,
    required this.reviewed,
    this.reviewerEmail,
    this.systemNameToAdd,
    this.systemBrandToAdd,
    this.systemToUpdate,
    this.problemToUpdate,
    this.solutionToUpdate,
  });

  factory UserRequest.fromMap({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return UserRequest(
      id: id,
      requestType: RequestTypeConverter.stringToType(data['requestType']),
      entityType: EntityTypeConverter.stringToType(data['entityType']),
      requestTitle: data['requestTitle'],
      requestDescription: data['requestDescription'],
      timestamp: data['timestamp'],
      systemNameToAdd: data['systemNameToAdd'],
      systemBrandToAdd: data['systemBrandToAdd'],
      systemToUpdate: data['systemToUpdate'],
      problemToUpdate: data['problemToUpdate'],
      solutionToUpdate: data['solutionToUpdate'],
      reviewerEmail: data['reviewerEmail'],
      userId: data['userId'],
      userEmail: data['userEmail'],
      reviewed: data['reviewed'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestType': RequestTypeConverter.typeToString(requestType),
      'entityType': EntityTypeConverter.typeToString(entityType),
      'requestTitle': requestTitle,
      'requestDescription': requestDescription,
      if (systemNameToAdd != null) 'systemNameToAdd': systemNameToAdd,
      if (systemBrandToAdd != null) 'systemBrandToAdd': systemBrandToAdd,
      if (systemToUpdate != null) 'systemToUpdate': systemToUpdate,
      if (problemToUpdate != null) 'problemToUpdate': problemToUpdate,
      if (solutionToUpdate != null) 'solutionToUpdate': solutionToUpdate,
      if (reviewerEmail != null) 'reviewerEmail': reviewerEmail,
      'timestamp': timestamp,
      'userEmail': userEmail,
      'userId': userId,
      'reviewed': reviewed,
    };
  }

  void markAsReviewed() => reviewed = true;
}
