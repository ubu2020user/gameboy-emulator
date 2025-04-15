import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Modal {
  /// Show a alert modal
  ///
  /// The onCancel callbacks receive BuildContext context as argument.
  static void alert(BuildContext context, String title, String message,
      {Function()? onCancel}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title),
              actions: [
                ElevatedButton(
                  child: Text('OK'),
                  // isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    onCancel?.call();
                  },
                )
              ],
              content: Text(message));
        });
  }
}
