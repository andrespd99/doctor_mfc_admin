import 'package:doctor_mfc_admin/constants.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionHeader({
    required this.title,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$title', style: textTheme.headline1),
        SizedBox(height: kDefaultPadding / 2),
        (subtitle != null)
            ? Text('$subtitle',
                style: textTheme.bodyText2
                    ?.copyWith(color: kFontBlack.withOpacity(0.5)))
            : Container(),
      ],
    );
  }
}
