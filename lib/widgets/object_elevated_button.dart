import 'package:doctor_mfc_admin/constants.dart';
import 'package:flutter/material.dart';

class ObjectElevatedButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final double? width;

  const ObjectElevatedButton({
    required this.title,
    required this.onPressed,
    this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 250,
      child: ElevatedButton(
        child: Row(
          children: [
            CircleAvatar(backgroundColor: kSecondaryLightColor, radius: 4),
            SizedBox(width: kDefaultPadding / 2),
            Expanded(
              child: Text(
                '$title',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(width: kDefaultPadding / 2),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Edit',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.apply(color: Colors.grey),
              ),
            )
          ],
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: Colors.grey[200],
            shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
      ),
    );
  }
}
