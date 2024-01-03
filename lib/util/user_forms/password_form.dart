import 'package:flutter/material.dart';

class PasswordForm extends StatefulWidget {
  final controller;

  PasswordForm({
    super.key,
    required this.controller,
  });

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: TextFormField(
        controller: widget.controller,
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
            borderSide: BorderSide(
              color: Color.fromRGBO(253, 123, 8, 1),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
            borderSide: BorderSide(
              color: Color.fromRGBO(98, 98, 98, 1),
            ),
          ),
          labelText: 'Password',
        ),
      ),
    );
  }
}
