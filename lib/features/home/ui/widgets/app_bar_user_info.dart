import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/routing/app_routes.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppBarUserInfo extends StatelessWidget {
  const AppBarUserInfo({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.grey,
          child: Icon(Icons.person_outline),
        ),
        horizontalSpace(15),
        Text(
          userName,
          style: AppTextStyles.font16DarkGreyMedium(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        horizontalSpace(10),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.pushReplacementNamed(AppRoutes.auth);
          },
        ),
      ],
    );
  }
}
