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

class MobileCustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MobileCustomAppBar({super.key});

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
            leading: _buildLeading(context, authData),
            titleSpacing: 5,
            leadingWidth: 250.w,
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

  Row _buildLeading(BuildContext context, AuthDataModel authData) {
    return Row(
      children: [
        Image.asset(
          Assets.assetsImagesPngIconLogo,
          scale: 2,
        ),
        horizontalSpace(10),
        Text(
          authData.clinicName,
          style: _getTextStyle(context),
        ),
      ],
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    return AppTextStyles.font16DarkGreyMedium(context).copyWith(
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
