import 'package:doctor_mfc_admin/constants.dart';
import 'package:flutter/material.dart';

class SectionSubheader extends StatelessWidget {
  final String title;

  const SectionSubheader(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$title', style: textTheme.headline5),
      ],
    );
  }
}
