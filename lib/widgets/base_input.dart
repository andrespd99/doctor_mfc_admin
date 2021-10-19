import 'package:doctor_mfc_admin/constants.dart';
import 'package:flutter/material.dart';

class BaseInput extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? subtitle;
  final String? hintText;
  final String? errorText;
  final double? width;

  const BaseInput({
    required this.title,
    required this.controller,
    this.subtitle,
    this.hintText,
    this.errorText,
    this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(width: kDefaultPadding / 2),
            (subtitle != null)
                ? Text(
                    subtitle!,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  )
                : Container(),
          ],
        ),
        SizedBox(height: kDefaultPadding / 2),
        Container(
          width: width,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              errorText: errorText,
            ),
          ),
        )
      ],
    );
  }
}
