import 'package:flutter/material.dart';

class FormMainButtons extends StatelessWidget {
  final String text;
  final Function function;
  final bool isMainButton;
  const FormMainButtons({
    super.key,
    required this.text,
    required this.function,
    required this.isMainButton,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        function();
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          isMainButton ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      child: isMainButton
          ? Row(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerLowest,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.double_arrow,
                  size: 30,
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerLowest,
                ),
              ],
            )
          : Text(text, style: TextStyle(fontSize: 16)),
    );
  }
}
