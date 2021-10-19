import 'package:doctor_mfc_admin/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Builds a Loading Indicator Alert Dialog that stays until the future has completed.
Future futureLoadingIndicator(BuildContext context, Future future) {
  return showDialog(
    context: context,
    builder: (context) {
      future
          .then((_) => Navigator.pop(context))
          .timeout(Duration(seconds: 15),
              onTimeout: () => onErrorDialog(context, 'Request timeout'))
          .onError((error, stackTrace) => onErrorDialog(context));

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
              children: [
                CircularProgressIndicator(color: kSecondaryLightColor),
                Text(
                  'Loading...',
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
    },
  );
}

void onErrorDialog(BuildContext context, [String? errorMessage]) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(errorMessage ?? 'An error has ocurred'),
          content: Text('Try again?'),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
            ),
            CupertinoDialogAction(child: Text('Retry'), isDefaultAction: true),
          ],
        );
      });
}
