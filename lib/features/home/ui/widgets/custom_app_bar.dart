import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/theming/assets.dart';
import 'package:el_sharq_clinic/features/home/ui/widgets/app_bar_user_info.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: _buildContainerDecoration(),
      child: AppBar(
        surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        leading: Image.asset(Assets.assetsImagesPngIconLogo),
        titleSpacing: 5,
        title: _buildTitle(),
        actions: [AppBarUserInfo(userName: userName)],
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return const BoxDecoration(
      color: AppColors.white,
      border: Border(
        bottom: BorderSide(
          color: AppColors.grey,
          width: 0.5,
        ),
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      'EL-Sharq Clinic',
      style: AppTextStyles.font22DarkGreyMedium.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
