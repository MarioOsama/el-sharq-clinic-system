part of 'auth_cubit.dart';

abstract class AuthState {
  void takeAction(BuildContext context) {}
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {
  @override
  void takeAction(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: FadedAnimatedLoadingIcon());
        });
  }
}

final class AuthSuccess extends AuthState {
  final AuthDataModel authData;

  AuthSuccess(this.authData);

  @override
  void takeAction(BuildContext context) {
    final String homeRoute = appFlavor.toString().capitalize() == 'Mobile'
        ? AppRoutes.homeMobile
        : AppRoutes.home;
    context.pop();
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppDialog(
        title: AppStrings.success.tr(),
        content: AppStrings.welcomeMessage.tr(),
        dialogType: DialogType.success,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.pop();
      }
    }).then((_) {
      if (context.mounted) {
        context.pushNamed(homeRoute, arguments: authData);
      }
    });
  }
}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  void takeAction(BuildContext context) {
    if (ModalRoute.of(context)?.isCurrent != true) context.pop();

    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppDialog(
        title: AppStrings.error.tr(),
        content: message,
        dialogType: DialogType.error,
        action: AppTextButton(
          text: AppStrings.ok.tr(),
          onPressed: () => context.pop(),
          filled: false,
        ),
      ),
    );
  }
}
