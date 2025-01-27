import 'package:flutter/material.dart';

class BlueButton extends ButtonStyle {
  BlueButton(context)
      : super(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
          backgroundColor: WidgetStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        );
}
