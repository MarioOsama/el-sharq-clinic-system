part of 'doctors_cubit.dart';

abstract class DoctorsState {
  void takeAction(BuildContext context) {}
}

final class DoctorsInitial extends DoctorsState {}

final class DoctorsLoading extends DoctorsState {}

final class DoctorsSuccess extends DoctorsState {
  final List<DoctorModel?> doctors;

  DoctorsSuccess({required this.doctors});
}

final class DoctorsError extends DoctorsState {
  final String message;

  DoctorsError(this.message);

  @override
  void takeAction(BuildContext context) {
    context.pop();

    showDialog(
        context: context,
        builder: (ctx) => AppDialog(
              title: 'Error',
              content: message,
              dialogType: DialogType.error,
              action: AppTextButton(
                text: 'OK',
                onPressed: () => context.pop(),
                filled: false,
              ),
            ));
  }
}

// Doctor states
final class DoctorLoading extends DoctorsState {
  @override
  void takeAction(BuildContext context) {
    showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: AnimatedLoadingIndicator());
        });
  }
}

final class DoctorSaved extends DoctorsState {
  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);
    context.pop();
    context.pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AppDialog(
        title: 'Success',
        content: 'Doctor saved successfully',
        dialogType: DialogType.success,
      ),
    );

    // Hide success dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.pop();
      }
    });
  }
}

final class DoctorUpdated extends DoctorsState {
  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);
    context.pop();
    context.pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AppDialog(
        title: 'Success',
        content: 'Doctor updated successfully',
        dialogType: DialogType.success,
      ),
    );

    // Hide success dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.pop();
      }
    });
  }
}

final class DoctorDeleted extends DoctorsState {
  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AppDialog(
        title: 'Success',
        content: 'Doctors deleted successfully',
        dialogType: DialogType.success,
      ),
    );

    // Hide success dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.pop();
      }
    });
  }
}
