import 'package:flutter/material.dart';

TextStyle formInputDecoration({required BuildContext context}) {
  return TextStyle(
    fontFamily: "Montserrat",
    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );
}
