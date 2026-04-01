import 'package:flutter/material.dart';

class TextLastUpdated extends StatelessWidget {
  final String text;
  const TextLastUpdated({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    print('text: $text');
    return Text(
      text,
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
