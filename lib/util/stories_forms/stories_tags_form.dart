import 'package:flutter/material.dart';


class storiesTagsForm extends StatefulWidget {
  final controller;

  storiesTagsForm({
    super.key,
    required this.controller,
  });

  @override
  State<storiesTagsForm> createState() => _storiesTagsFormState();
}

class _storiesTagsFormState extends State<storiesTagsForm> {
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
          
          labelText: 'Tags',
        ),
      ),
    );
    
  }
}
