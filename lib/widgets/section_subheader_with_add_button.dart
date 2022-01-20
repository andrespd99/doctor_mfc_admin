import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/widgets/text_button_light_bg.dart';
import 'package:flutter/material.dart';

class SectionSubheaderWithButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final String buttonText;
  final Color? buttonColor;

  final bool enableManageButton;
  final Function()? onManageButtonPressed;
  final bool manageModeEnabled;

  const SectionSubheaderWithButton({
    required this.title,
    required this.onPressed,
    required this.buttonText,
    this.enableManageButton = false,
    this.onManageButtonPressed,
    this.manageModeEnabled = false,
    this.buttonColor,
    Key? key,
  })  : assert(enableManageButton == true && onManageButtonPressed != null ||
            enableManageButton == false),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$title', style: Theme.of(context).textTheme.headline6),
        SizedBox(height: kDefaultPadding / 3),
        TextButton(
          child: Text('$buttonText'),
          onPressed: (onPressed != null) ? () => onPressed!() : null,
          style: TextButton.styleFrom(
            primary: (buttonColor != null) ? buttonColor : kSecondaryColor,
          ),
        ),
        Spacer(),
        enableManageButton
            ? TextButton(
                onPressed: () => onManageButtonPressed!(),
                child: Text((!manageModeEnabled) ? 'Manage' : 'Finish'),
                style: TextButton.styleFrom(
                  primary: kFontBlack.withOpacity(0.5),
                ),
              )
            : Container(),
      ],
    );
  }
}
