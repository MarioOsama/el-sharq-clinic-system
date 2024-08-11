import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/assets.dart';
import 'package:el_sharq_clinic/core/widgets/app_drop_down_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.assetsImagesPngTextLogo),
            verticalSpace(50),
            const AppDropDownButton(
              items: AppConstant.clinicsList,
            ),
            verticalSpace(25),
            AppTextField(
              controller: TextEditingController(),
              hint: 'Username',
            ),
            verticalSpace(25),
            AppTextField(
              controller: TextEditingController(),
              hint: 'Password',
              isObscured: true,
            ),
            verticalSpace(30),
            AppTextButton(
              text: 'Open System',
              onPressed: () async {
                await windowManager.setFullScreen(false);
              },
            )
          ],
        ),
      ),
    );
  }
}
