/* External dependencies */
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

enum SnackBarStatuses { success, warning, error }

class AppSnackBar {
  static int _activeToasts = 0;
  static const int _maxActiveToasts = 1;

  static void showSnackBar(
    BuildContext context,
    String text, {
    SnackBarStatuses status = SnackBarStatuses.error,
    int durationInSeconds = 4,
  }) {
    if (_activeToasts < _maxActiveToasts) {
      _activeToasts = _activeToasts + 1;

      IconData icon = Icons.error;
      Color backgroundColor = Colors.red;

      if (status == SnackBarStatuses.warning) {
        icon = Icons.warning;
        backgroundColor = Colors.orange;
      } else if (status == SnackBarStatuses.success) {
        icon = Icons.check_circle;
      }

      Toastification().show(
        backgroundColor: backgroundColor,
        primaryColor: Colors.white,
        foregroundColor: Colors.white,
        context: context,
        animationBuilder: (context, animation, alignment, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        callbacks: ToastificationCallbacks(
          onDismissed: (value) {
            _activeToasts--;
          },
          onAutoCompleteCompleted: (value) {
            _activeToasts--;
          },
        ),
        overlayState: Overlay.of(context),
        type: ToastificationType.error,
        closeOnClick: false,
        closeButtonShowType: CloseButtonShowType.none,
        style: ToastificationStyle.flat,
        description: Text(
          text,
          maxLines: 10,
        ),
        alignment: Alignment.topCenter,
        showProgressBar: false,
        dismissDirection: DismissDirection.vertical,
        icon: Icon(icon),
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
        borderRadius: BorderRadius.circular(12),
        autoCloseDuration: Duration(seconds: durationInSeconds),
      );
    }

    if (_activeToasts < 0) {
      _activeToasts = 0;
    }
  }
}
