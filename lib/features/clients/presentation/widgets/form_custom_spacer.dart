import 'package:flutter/material.dart';

class FormCustomSpacer extends StatelessWidget {
  final double? optionalHeight;
  const FormCustomSpacer({super.key, this.optionalHeight});
  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;

    return SizedBox(height: optionalHeight ?? currentHeight * 0.01);
  }
}
