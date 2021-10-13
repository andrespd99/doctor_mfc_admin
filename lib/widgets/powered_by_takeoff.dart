import 'package:doctor_mfc_admin/constants.dart';
import 'package:flutter/material.dart';

class PoweredByTakeoffWidget extends StatelessWidget {
  final double? height;
  const PoweredByTakeoffWidget({this.height, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Powered by',
          style:
              Theme.of(context).textTheme.caption?.copyWith(color: kFontWhite),
        ),
        Image.asset(
          'assets/takeoff_logo_2.png',
          height: height ?? 60,
        )
      ],
    );
  }
}
