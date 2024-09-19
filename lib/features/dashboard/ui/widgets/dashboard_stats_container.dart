import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class DashboardStatsContainer extends StatelessWidget {
  const DashboardStatsContainer(
      {super.key, required this.child, this.padding, this.height, this.width});

  final Widget child;
  final EdgeInsets? padding;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      height: height,
      width: width,
      decoration: _buildBoxDecoration(),
      child: child,
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: AppColors.white,
      border: Border.all(
        color: AppColors.darkGrey.withOpacity(0.25),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withOpacity(0.15),
          blurRadius: 10,
          spreadRadius: 5,
          offset: const Offset(5, 5),
        ),
      ],
    );
  }
}
