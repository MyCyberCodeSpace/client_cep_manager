import 'package:flutter/material.dart';

InputDecoration loginInputDecoration({
  required BuildContext context,
  required String text,
}) {
  return InputDecoration(
    hintText: text,
    hintStyle: TextStyle(
      color: Theme.of(
        context,
      ).colorScheme.onSurface.withValues(alpha: 0.3),
      fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
    ),

    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 25,
    ),
    errorStyle: TextStyle(fontSize: 10),
  );
}
