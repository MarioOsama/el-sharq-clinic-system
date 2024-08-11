import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/assets.dart';
import 'package:el_sharq_clinic/core/widgets/app_drop_down_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/features/auth/logic/cubit/auth_cubit.dart';
import 'package:el_sharq_clinic/features/auth/ui/widgets/auth_bloc_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            AppDropDownButton(
              items: AppConstant.clinicsList,
              onChanged: (value) {
                context.read<AuthCubit>().selectClinic(value!);
              },
            ),
            verticalSpace(25),
            AppTextField(
              controller: context.read<AuthCubit>().usernameController,
              hint: 'Username',
            ),
            verticalSpace(25),
            AppTextField(
              controller: context.read<AuthCubit>().passwordController,
              hint: 'Password',
              isObscured: true,
            ),
            verticalSpace(30),
            AppTextButton(
              text: 'Open System',
              onPressed: () {
                context.read<AuthCubit>().openSystem();
              },
            ),
            const AuthBlocListener(),
          ],
        ),
      ),
    );
  }
}
