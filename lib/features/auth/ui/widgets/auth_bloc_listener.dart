import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/routing/app_routes.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/auth/logic/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBlocListener extends StatelessWidget {
  const AuthBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          // check if the dialog is already shown
          if (ModalRoute.of(context)!.isCurrent != true) {
            context.pop();
          }
          showDialog<String>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              });
        }

        if (state is AuthSuccess) {
          if (ModalRoute.of(context)!.isCurrent != true) {
            context.pop();
          }
          showDialog<String>(
            context: context,
            builder: (context) => const AppDialog(
              title: 'Success',
              content: 'Welcome to the system',
              dialogType: DialogType.success,
            ),
          );
          Future.delayed(const Duration(seconds: 2), () => context.pop()).then(
              (_) =>
                  context.pushNamed(AppRoutes.home, arguments: state.authData));
        }
        if (state is AuthFailure) {
          if (ModalRoute.of(context)!.isCurrent != true) {
            context.pop();
          }
          showDialog<String>(
            context: context,
            builder: (context) => AppDialog(
              title: 'Error',
              content: state.message,
              dialogType: DialogType.error,
              action: AppTextButton(
                text: 'OK',
                onPressed: () => context.pop(),
                filled: false,
              ),
            ),
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
