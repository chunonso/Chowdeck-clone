import 'package:flutter/material.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';

class NotificationAlert {
  static void showErrorAlert(BuildContext context, String message) {
    ElegantNotification.error(
      height: 80,
      showProgressIndicator: false,
      position: Alignment.topCenter,
      animation: AnimationType.fromTop,
      displayCloseButton: false,
      description: Text(message),
    ).show(context);
  }

  static void showSuccessAlert(BuildContext context, String message) {
    ElegantNotification.success(
      height: 80,
      showProgressIndicator: false,
      position: Alignment.topCenter,
      animation: AnimationType.fromTop,
      displayCloseButton: false,
      description: Text(message),
    ).show(context);
  }
}
