import 'package:flutter/material.dart';

InputDecoration formInputDecorationHint({
  required BuildContext context,
  required String text,
}) {
  return InputDecoration(
    hintText: text,
    filled: true,
    fillColor: Theme.of(context).colorScheme.surfaceContainer,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    hintStyle: TextStyle(
      fontFamily: "Montserrat",
      color: Theme.of(
        context,
      ).colorScheme.onSurface.withValues(alpha: 0.3),
      fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
      fontWeight: FontWeight.bold,
    ),
  );
}
