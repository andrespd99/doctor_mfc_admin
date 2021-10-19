import 'package:doctor_mfc_admin/constants.dart';
import 'package:flutter/material.dart';

class TextButtonLightBackground extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  const TextButtonLightBackground({
    required this.onPressed,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (onPressed != null) ? () => onPressed!() : null,
      child: child,
      style: TextButton.styleFrom(
        primary: kSecondaryColor,
      ),
    );
  }
}
