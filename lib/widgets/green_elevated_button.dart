import 'package:doctor_mfc_admin/constants.dart';
import 'package:flutter/material.dart';

class GreenElevatedButton extends StatelessWidget {
  final Widget? child;
  final Function() onPressed;
  const GreenElevatedButton({
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
        primary: kPrimaryColor.withOpacity(0.8),
      ),
    );
  }
}
