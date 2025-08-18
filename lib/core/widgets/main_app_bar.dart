import 'package:flutter/material.dart';

AppBar mainAppBar({
  required BuildContext context,
  required String text,
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new,
        size: 40,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    centerTitle: true,
    title: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
        fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    toolbarHeight: 80,
  );
}
