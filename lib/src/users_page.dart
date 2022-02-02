import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/app_user.dart';
import 'package:doctor_mfc_admin/services/database.dart';

import 'package:doctor_mfc_admin/src/create_user_dialog.dart';
import 'package:doctor_mfc_admin/widgets/body_template.dart';
import 'package:doctor_mfc_admin/widgets/custom_loading_indicator.dart';
import 'package:doctor_mfc_admin/widgets/future_loading_indicator.dart';

import 'package:doctor_mfc_admin/widgets/green_elevated_button.dart';

import 'package:doctor_mfc_admin/widgets/text_button_light_bg.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return BodyTemplate(
      title: 'Users',
      body: [
        GreenElevatedButton(
          child: Text('Create new user'),
          onPressed: () => openUserCreationDialog(),
        ),
        SizedBox(height: kDefaultPadding * 2),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: TextButton(
        //     child: Text(
        //       'Advanced options',
        //     ),
        //     style: TextButton.styleFrom(
        //       primary: Colors.grey,
        //     ),
        //     onPressed: () {},
        //   ),
        // ),
        // SizedBox(height: kDefaultPadding / 2),
        usersList(),
      ],
    );
  }

  /// Returns a StreamBuilder for the list of users.
  Widget usersList() {
    return StreamBuilder<QuerySnapshot<AppUser>>(
      stream: Database().getUsersSnapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<AppUser> users =
              snapshot.data!.docs.map((doc) => doc.data()).toList();

          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, i) => userCard(users[i]),
            separatorBuilder: (context, i) =>
                SizedBox(height: kDefaultPadding / 2),
          );
        } else
          return CustomLoadingIndicator();
      },
    );
  }

  /// Returns a User card widget with all it's information and actions.
  Widget userCard(AppUser user) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      color: Colors.black.withOpacity(0.05),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${user.userName}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  // If user is disabled, shows a disabled tag.
                  if (isUserDisabled(user)) ...[
                    SizedBox(width: kDefaultPadding / 2),
                    disabledTag(),
                  ],
                ],
              ),
              SizedBox(height: kDefaultPadding * 1.5),
              Text('${user.userEmail}'),
            ],
          ),
          Spacer(),
          (isUserDisabled(user))
              ? TextButtonLightBackground(
                  child: Text('Enable user'),
                  onPressed: () => promptEnableUser(user),
                )
              : TextButton(
                  child: Text('Disable user'),
                  onPressed: () => promptDisableUser(user),
                  style: TextButton.styleFrom(primary: Colors.red),
                ),
        ],
      ),
    );
  }

  /// Opens a dialog for user creation.
  void openUserCreationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CreateUserDialog();
      },
    );
  }

  /// Shows a dialog to confirm user disabling.
  void promptDisableUser(AppUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Disable user',
          style: TextStyle(color: Colors.red[600]),
        ),
        content: Text(
            'Are you sure you want to disable the user of ${user.userName}?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            style: TextButton.styleFrom(primary: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text('Disable'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              futureLoadingIndicator(context, disableUser(user))
                  .then((value) => Navigator.of(context).pop());
            },
          ),
        ],
      ),
    );
  }

  /// Returns a tag displayed after an user that's disabled.
  Widget disabledTag() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding / 3,
        vertical: kDefaultPadding / 6,
      ),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        border: Border.all(
          color: Colors.red.shade600,
        ),
      ),
      child: Text(
        'Disabled',
        style: TextStyle(
          fontSize: 10,
          color: Colors.red[600],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Shows a dialog to confirm user enabling.
  void promptEnableUser(AppUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enable user'),
        content: Text('Do you want to enable the user of ${user.userName}?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            style: TextButton.styleFrom(primary: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
          GreenElevatedButton(
            child: Text('Enable'),
            onPressed: () {
              futureLoadingIndicator(context, enableUser(user))
                  .then((value) => Navigator.of(context).pop());
            },
          ),
        ],
      ),
    );
  }

  /// Calls [Database] function to disable the user.
  Future disableUser(AppUser user) async =>
      await Database().disableUser(user.id);

  /// Calls [Database] function to enable the user.
  Future enableUser(AppUser user) async => await Database().enableUser(user.id);

  /// Returns if user is disabled.
  bool isUserDisabled(AppUser user) {
    if (user.disabled == null || user.disabled == false)
      return false;
    else
      return true;
  }
}
