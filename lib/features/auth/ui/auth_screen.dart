import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
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
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Center(
            child: _buildChild(context, state),
          );
        },
      ),
    );
  }

  Widget _buildChild(BuildContext context, AuthState state) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInUp(
              duration: const Duration(seconds: 2),
              delay: const Duration(milliseconds: 1000),
              from: 500,
              child: Image.asset(Assets.assetsImagesPngTextLogo)),
          verticalSpace(50),
          FadeInLeft(
              duration: const Duration(seconds: 1),
              delay: const Duration(milliseconds: 3000),
              child: _buildDropDownButton(context)),
          verticalSpace(25),
          FadeInRight(
            duration: const Duration(seconds: 1),
            delay: const Duration(milliseconds: 3000),
            child: AppTextField(
              controller: context.read<AuthCubit>().usernameController,
              hint: AppStrings.userName.tr(),
              insideHint: true,
            ),
          ),
          verticalSpace(25),
          FadeInLeft(
            duration: const Duration(seconds: 1),
            delay: const Duration(milliseconds: 3000),
            child: AppTextField(
              controller: context.read<AuthCubit>().passwordController,
              hint: AppStrings.password.tr(),
              insideHint: true,
              isObscured: true,
            ),
          ),
          verticalSpace(30),
          FadeInRight(
            duration: const Duration(seconds: 1),
            delay: const Duration(milliseconds: 3000),
            child: AppTextButton(
              text: AppStrings.openSystem.tr(),
              onPressed: () {
                context.read<AuthCubit>().openSystem();
              },
            ),
          ),
          const AuthBlocListener(),
        ],
      ),
    );
  }

  AppDropDownButton _buildDropDownButton(BuildContext context) {
    final AuthCubit cubit = context.read<AuthCubit>();
    return AppDropDownButton(
      items: cubit.clinicNames,
      initialValue: context.watch<AuthCubit>().selectedClinic,
      onChanged: (value) {
        cubit.selectClinic(value!);
      },
    );
  }
}
