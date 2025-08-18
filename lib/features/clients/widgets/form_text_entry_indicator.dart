import 'package:flutter/material.dart';

class FormTextEntryIndicator extends StatelessWidget {
  final String text;
  const FormTextEntryIndicator({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
