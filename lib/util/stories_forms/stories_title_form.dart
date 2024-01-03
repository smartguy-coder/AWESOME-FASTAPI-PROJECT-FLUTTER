import 'package:flutter/material.dart';

class storiesTitleForm extends StatefulWidget {
  final controller;

  storiesTitleForm({
    super.key,
    required this.controller,
  });

  @override
  State<storiesTitleForm> createState() => _storiesTitleFormState();
}

class _storiesTitleFormState extends State<storiesTitleForm> {
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
          
          labelText: 'Title',
        ),
      ),
    );
  }
}
