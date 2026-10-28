import 'package:flutter/material.dart';

enum AppButtonType { primary, secondary, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isExpanded;
  final Widget? icon;
  final AppButtonType type;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = false,
    this.icon,
    this.type = AppButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == AppButtonType.primary
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    Widget button;
    switch (type) {
      case AppButtonType.primary:
        button = FilledButton(
          onPressed: isLoading ? null : onPressed,
          child: buttonChild,
        );
        break;
      case AppButtonType.secondary:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: buttonChild,
        );
        break;
      case AppButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          child: buttonChild,
        );
        break;
    }

    return isExpanded
        ? SizedBox(
            width: double.infinity,
            child: button,
          )
        : button;
  }
}
