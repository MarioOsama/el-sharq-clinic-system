part of 'settings_cubit.dart';

abstract class SettingsState {
  void takeAction(BuildContext context) {}
}

final class SettingsInitial extends SettingsState {}

final class SettingsChanged extends SettingsState {}

final class SettingsLoading extends SettingsState {
  @override
  void takeAction(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => const AnimatedLoadingIndicator());
  }
}

final class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);
}

final class SettingsUpdated extends SettingsState {
  final AuthDataModel authData;
  final String message;
  final int? popCount;

  SettingsUpdated(
      {required this.authData, required this.message, this.popCount = 1});

  // Updating auth data in MainCubit
  @override
  void takeAction(BuildContext context) {
    for (int i = 0; i < popCount!; i++) {
      context.pop();
    }
    context.read<MainCubit>().updateAuthData(authData);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AppDialog(
              title: 'Success',
              content: message,
              dialogType: DialogType.success,
            ));

    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.pop();
      }
    });
  }
}

final class SettingsUpdatingError extends SettingsState {
  final String message;
  final int popCount;

  SettingsUpdatingError(this.message, {this.popCount = 1});

  @override
  void takeAction(BuildContext context) {
    for (int i = 0; i < popCount; i++) {
      context.pop();
    }
    showDialog(
        context: context,
        builder: (context) => AppDialog(
              title: 'Error',
              content: message,
              dialogType: DialogType.error,
              action: AppTextButton(
                text: 'OK',
                filled: false,
                onPressed: () {
                  context.pop();
                },
              ),
            ));
  }
}
