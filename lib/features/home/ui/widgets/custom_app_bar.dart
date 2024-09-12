import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/logic/cubit/main_cubit.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/theming/assets.dart';
import 'package:el_sharq_clinic/features/home/ui/widgets/app_bar_user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MainCubit, MainState, AuthDataModel>(
      selector: (state) {
        return state.authDataModel;
      },
      builder: (context, authData) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: _buildContainerDecoration(),
          child: AppBar(
            surfaceTintColor: AppColors.white,
            backgroundColor: AppColors.white,
            leading: _buildLeading(context),
            titleSpacing: 5,
            title: _buildTitle(authData, context),
            leadingWidth: 250.w,
            centerTitle: true,
            actions: [AppBarUserInfo(userName: authData.userModel.userName)],
          ),
        );
      },
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

  Row _buildLeading(BuildContext context) {
    return Row(
      children: [
        Image.asset(Assets.assetsImagesPngIconLogo),
        horizontalSpace(20),
        Text(
          'EL-Sharq Clinic',
          style: AppTextStyles.font22DarkGreyMedium(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Text _buildTitle(AuthDataModel authData, BuildContext context) {
    return Text(
      authData.clinicName,
      style: AppTextStyles.font22DarkGreyMedium(context).copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
