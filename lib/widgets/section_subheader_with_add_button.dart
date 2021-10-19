import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/widgets/text_button_light_bg.dart';
import 'package:flutter/material.dart';

class SectionSubheaderWithAddButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final String addButtonText;

  const SectionSubheaderWithAddButton({
    required this.title,
    required this.onPressed,
    required this.addButtonText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$title', style: Theme.of(context).textTheme.headline6),
        SizedBox(height: kDefaultPadding / 3),
        TextButtonLightBackground(
          child: Text('$addButtonText'),
          onPressed: (onPressed != null) ? () => onPressed!() : null,
        ),
      ],
    );
  }
}
