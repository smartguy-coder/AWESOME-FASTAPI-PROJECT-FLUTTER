import 'package:flutter/material.dart';

import '../util/my_button.dart';

class MyAlertPage extends StatefulWidget {
  final text;
  final buttonText;
  final needInButton;
  final needInAppTitle;
  final onButtonPress;
  final titleText;
  final functionWhenLoad;
  final needInFutureBuilder;

  MyAlertPage({
    // Text
    this.text, // not required if isFromLogin or isFromRegister is true

    // Button
    this.buttonText = 'OK',
    this.needInButton = false,
    required this.onButtonPress,

    // Extra
    required this.functionWhenLoad,
    required this.needInFutureBuilder,

    // Title
    this.needInAppTitle = false,
    this.titleText = '',
  });

  @override
  State<MyAlertPage> createState() => _MyAlertPageState();
}

class _MyAlertPageState extends State<MyAlertPage> {
  Scaffold getBasicScaffold({required String text}) {
    return Scaffold(
      appBar: widget.needInAppTitle
          ? AppBar(
              title: Text('Your Title'),
              // Other AppBar properties like actions, leading, etc.
            )
          : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Center(
              child: widget.needInButton
                  ? MyButton(
                      text: widget.buttonText, onPressed: widget.onButtonPress)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.needInFutureBuilder
        ? FutureBuilder(
            future: widget.functionWhenLoad(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return getBasicScaffold(
                    text: widget.text != null ? widget.text : snapshot.data);
              } else {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary),
                      ],
                    ),
                  ),
                );
              }
            },
          )
        : getBasicScaffold(text: widget.text);
  }
}
