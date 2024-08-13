import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class SectionDetailsContainer extends StatelessWidget {
  const SectionDetailsContainer({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: padding ?? const EdgeInsets.all(35),
      decoration: _buildContainerDecoration(),
      child: child,
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: AppColors.white,
    );
  }
}
