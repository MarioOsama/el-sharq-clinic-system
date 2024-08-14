part of 'case_history_cubit.dart';

abstract class CaseHistoryState {
  void showMessage(BuildContext context);
}

final class CaseHistoryInitial implements CaseHistoryState {
  @override
  void showMessage(BuildContext context) {}
}

final class CaseHistoryLoading extends CaseHistoryState {
  @override
  void showMessage(BuildContext context) {}
}

final class CaseHistorySuccess extends CaseHistoryState {
  @override
  void showMessage(BuildContext context) {}
}

final class CaseHistoryError extends CaseHistoryState {
  final String errorMessage;

  CaseHistoryError(this.errorMessage);

  @override
  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AppDialog(
              title: 'Error',
              content: errorMessage,
              dialogType: DialogType.error,
              action: AppTextButton(
                text: 'OK',
                onPressed: () => context.pop(),
                filled: false,
              ),
            ));
  }
}

// New appointment
final class NewAppointmentInvalid extends CaseHistoryState {
  final String? title;
  final String errorMessage;

  NewAppointmentInvalid(this.errorMessage, {this.title});

  @override
  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AppDialog(
              title: title ?? 'Error',
              content: errorMessage,
              dialogType: DialogType.error,
              action: AppTextButton(
                text: 'OK',
                onPressed: () => context.pop(),
                filled: false,
              ),
            ));
  }
}

final class NewAppointmentLoading extends CaseHistoryState {
  @override
  void showMessage(BuildContext context) {}
}

final class NewCaseHistoryuccess extends CaseHistoryState {
  @override
  void showMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const AppDialog(
        title: 'Success',
        content: 'Appointment created successfully',
        dialogType: DialogType.success,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () => context.pop());
  }
}

final class NewAppointmentFailure extends CaseHistoryState {
  final String errorMessage;

  NewAppointmentFailure(this.errorMessage);

  @override
  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AppDialog(
              title: 'Error',
              content: errorMessage,
              dialogType: DialogType.error,
              action: AppTextButton(
                text: 'OK',
                onPressed: () => context.pop(),
                filled: false,
              ),
            ));
  }
}
