import 'package:doctor_mfc_admin/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Builds a Loading Indicator Alert Dialog that stays until the future has completed.
Future futureLoadingIndicator(BuildContext context, Future future) {
  return showDialog(
    context: context,
    builder: (context) {
      future.then((_) => Navigator.pop(context)).timeout(Duration(seconds: 3),
          onTimeout: () {
        Navigator.pop(context);
        onErrorDialog(
          context: context,
          errorMessage: 'Request timeout',
          onTryAgainFuture: future,
        );
      }).onError(
        (error, stackTrace) => onErrorDialog(
          context: context,
          errorMessage: 'An unexpected error has ocurred',
          onTryAgainFuture: future,
        ),
      );

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
    },
  );
}

void onErrorDialog({
  required BuildContext context,
  String? errorMessage,
  Future? onTryAgainFuture,
}) {
  showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Error'),
          content: Text(errorMessage ?? 'An error has ocurred'),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            (onTryAgainFuture != null)
                ? CupertinoDialogAction(
                    child: Text('Try again'),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                      futureLoadingIndicator(context, onTryAgainFuture);
                    })
                : Container(),
          ],
        );
      });
}
