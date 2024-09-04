import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class SectionDetailsContainer extends StatelessWidget {
  const SectionDetailsContainer(
      {super.key,
      required this.child,
      this.padding,
      this.color,
      this.borderRadiusValue,
      this.borderRadius});

  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final double? borderRadiusValue;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      alignment: Alignment.topLeft,
      padding: padding ?? EdgeInsets.zero,
      decoration: _buildContainerDecoration(),
      child: child,
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      borderRadius:
          borderRadius ?? BorderRadius.circular(borderRadiusValue ?? 10),
      color: color ?? AppColors.white,
    );
  }
}
