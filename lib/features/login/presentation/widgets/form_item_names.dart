import 'package:flutter/material.dart';

class FormItemNames extends StatelessWidget {
  final String text;
  const FormItemNames({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
