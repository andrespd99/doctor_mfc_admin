import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/user_response.dart';
import 'package:flutter/material.dart';

class UserResponseElevatedButton extends StatelessWidget {
  final UserResponse response;
  final Function() onPressed;
  final double? width;

  const UserResponseElevatedButton({
    required this.response,
    required this.onPressed,
    this.width,
    Key? key,
  }) : super(key: key);

  bool get isOkResponse => response.isOkResponse;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width ?? 250,
      child: ElevatedButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
                // Red if is a failing response, green otherwise.
                backgroundColor:
                    (isOkResponse) ? kSecondaryLightColor : kAccentColor,
                radius: 4),
            SizedBox(width: kDefaultPadding / 2),
            Text(
              '${response.description}',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(width: kDefaultPadding / 2),
            Text(
              trailingText(),
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.apply(color: Colors.grey),
            )
          ],
        ),
        // If this response is not editable, onPressed function will be disabled
        onPressed: (response.isEditable) ? onPressed : null,
        style: ElevatedButton.styleFrom(
            primary: Colors.grey[200],
            shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
      ),
    );
  }

  String trailingText() {
    if (response.isOkResponse == false) {
      // This is a failing response
      // Show how many solutions are linked to this response.
      return 'Edit solutions (${response.solutions.length})';
    } else if (response.isOkResponse && response.isEditable == false) {
      // This is a 'Yes' response. Edition is disabled.
      return '';
    } else {
      // This is a working response but can be edited.
      return 'Edit';
    }
  }
}
