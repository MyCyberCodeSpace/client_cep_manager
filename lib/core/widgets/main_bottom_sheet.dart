import 'package:flutter/material.dart';

Padding mainBottomSheet() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 35),
    child: Container(
      color: Colors.transparent,
      child: Opacity(
        opacity: 0.3,
        child: Image.asset(
          'assets/app/logo_and_name.png',
          height: 100,
        ),
      ),
    ),
  );
}
