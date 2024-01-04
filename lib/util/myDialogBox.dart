import 'package:flutter/material.dart';

import '../internal/access_internal_storage.dart';
import 'my_button.dart';

InternalDatabase db = InternalDatabase();
Future<void> showDialogBox({
  required context,
  required String text,
  String title = '',
  String buttonText = 'OK',
  var buttonPressed,
}) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      if (buttonPressed != null) {
      } else {
        buttonPressed = () {
          Navigator.of(context).pop();
        };
      }

      return AlertDialog(
          scrollable: true,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(15.0),
            ),
            side: BorderSide(
              width: 0,
              color: Colors.transparent,
            ),
          ),
          title: title.length > 0 ? Text(title) : null,
          content: Column(children: [
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            MyButton(text: buttonText, onPressed: buttonPressed),
          ]));
    },
  );
}
