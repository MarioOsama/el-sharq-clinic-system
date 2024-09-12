import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.style});

  final String title;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: style ??
          AppTextStyles.font24DarkGreyMedium(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
