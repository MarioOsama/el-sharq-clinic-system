part of 'appointments_cubit.dart';

abstract class AppointmentsState {
  void showMessage(BuildContext context);
}

final class AppointmentsInitial implements AppointmentsState {
  @override
  void showMessage(BuildContext context) {}
}

final class AppointmentsLoading extends AppointmentsState {
  @override
  void showMessage(BuildContext context) {}
}

final class AppointmentsSuccess extends AppointmentsState {
  @override
  void showMessage(BuildContext context) {}
}

final class AppointmentsError extends AppointmentsState {
  final String errorMessage;

  AppointmentsError(this.errorMessage);

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
final class NewAppointmentInvalid extends AppointmentsState {
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

final class NewAppointmentLoading extends AppointmentsState {
  @override
  void showMessage(BuildContext context) {}
}

final class NewAppointmentSuccess extends AppointmentsState {
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

final class NewAppointmentFailure extends AppointmentsState {
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
