import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/widgets/loading_indicator_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Builds a Loading Indicator Alert Dialog that stays until the future has completed.
Future<T?> futureLoadingIndicator<T>(BuildContext context, Future<T> future) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      // future.then<T?>((result) {
      future.then<T?>((result) {
        // If the future completes successfully, dismiss the dialog.
        Navigator.pop(context, result);
      }, onError: (error, stackTrace) {
        // If the future completes with an error, dismiss the loading dialog
        // and show the error dialog.
        Navigator.pop(context);

        onErrorDialog(
          context: context,
          errorMessage: 'An unexpected error has ocurred: $error',
          onTryAgainFuture: future,
          error: error,
          stackTrace: stackTrace,
        );
      }).timeout(Duration(seconds: 15), onTimeout: () {
        // If the future times out, dismiss the loading dialog
        // and show the error dialog with a Request Timeout message.
        Navigator.pop(context);
        onErrorDialog(
          context: context,
          errorMessage: 'Request timeout',
          onTryAgainFuture: future,
        );
      });
      return LoadingIndicatorContainer();
    },
  );
}

Future onErrorDialog({
  required BuildContext context,
  String? errorMessage,
  Future? onTryAgainFuture,
  Object? error,
  StackTrace? stackTrace,
}) {
  print(error);
  print(stackTrace);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage ?? 'An error has ocurred'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          (onTryAgainFuture != null)
              ? TextButton(
                  child: Text('Try again'),
                  onPressed: () {
                    Navigator.pop(context);
                    futureLoadingIndicator(context, onTryAgainFuture);
                  })
              : Container(),
        ],
      );
    },
  );
}
