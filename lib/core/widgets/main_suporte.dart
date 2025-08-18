import 'package:flutter/material.dart';
import 'package:log_aqua_app/core/widgets/main_bottom_sheet.dart';

class MainSuporte extends StatelessWidget {
  const MainSuporte({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Opps.. entre em contato com o suporte',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Theme.of(
              context,
            ).textTheme.bodyMedium!.fontSize,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      bottomSheet: mainBottomSheet(),
    );
  }
}
