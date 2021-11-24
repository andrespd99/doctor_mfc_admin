import 'package:doctor_mfc_admin/constants.dart';
import 'package:flutter/material.dart';

class AlertElevatedButton extends StatelessWidget {
  final Widget? child;
  final Function() onPressed;

  const AlertElevatedButton({
    required this.child,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: child,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: kAccentColor.withOpacity(1.0),
      ),
    );
  }
}
