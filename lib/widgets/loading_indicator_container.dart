import 'package:doctor_mfc_admin/constants.dart';
import 'package:flutter/material.dart';

class LoadingIndicatorContainer extends StatelessWidget {
  const LoadingIndicatorContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: kSecondaryLightColor),
              SizedBox(height: kDefaultPadding / 2),
              Text(
                'Loading',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.apply(color: kSecondaryLightColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
