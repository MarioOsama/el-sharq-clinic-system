import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';

class StatisticsItemTitle extends StatelessWidget {
  const StatisticsItemTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.font20DarkGreyMedium(context),
    );
  }
}
