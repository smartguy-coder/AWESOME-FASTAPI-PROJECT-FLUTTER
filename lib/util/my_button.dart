import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String text;
  final onPressed;
  MyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      onPressed: widget.onPressed,
      color: Theme.of(context).colorScheme.onPrimary,
      textColor: Colors.white,
      elevation: 0,
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
