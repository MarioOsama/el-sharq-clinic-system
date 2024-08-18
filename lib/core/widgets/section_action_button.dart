import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:flutter/material.dart';

class SectionActionButton extends StatelessWidget {
  const SectionActionButton(
      {super.key,
      required this.valueNotifier,
      required this.onNewPressed,
      required this.onDeletePressed,
      this.newText,
      this.deleteText});

  final ValueNotifier<bool> valueNotifier;
  final Function() onNewPressed;
  final Function() onDeletePressed;
  final String? newText;
  final String? deleteText;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: valueNotifier,
      builder: (ctx, child) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: valueNotifier.value
            ? _buildDeleteCaseButton(context)
            : _buildNewCaseButton(context),
      ),
    );
  }

  AppTextButton _buildNewCaseButton(BuildContext context) {
    return AppTextButton(
      key: const ValueKey('new_case_button'),
      text: newText ?? 'New',
      icon: Icons.add,
      onPressed: onNewPressed,
      width: 200,
    );
  }

  AppTextButton _buildDeleteCaseButton(BuildContext context) {
    return AppTextButton(
      key: const ValueKey('delete_case_button'),
      text: deleteText ?? 'Delete',
      icon: Icons.delete,
      color: AppColors.red,
      onPressed: onDeletePressed,
      width: 200,
    );
  }
}
