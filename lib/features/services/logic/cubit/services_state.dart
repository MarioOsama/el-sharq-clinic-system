part of 'services_cubit.dart';

abstract class ServicesState {
  void takeAction(BuildContext context) {}
}

final class ServicesInitial extends ServicesState {}

final class ServicesLoading extends ServicesState {}

final class ServicesSuccess extends ServicesState {
  final List<ServiceModel> services;
  ServicesSuccess({required this.services});
}

final class ServicesError extends ServicesState {
  final String message;
  ServicesError(this.message);

  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);

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
      ),
    );
  }
}

// Single service states

final class ServiceSaving extends ServicesState {
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

final class ServiceAdded extends ServicesState {
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
        content: 'Service saved successfully',
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

final class ServiceUpdated extends ServicesState {
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
        content: 'Service updated successfully',
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

final class ServiceDeleted extends ServicesState {
  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AppDialog(
        title: 'Success',
        content: 'Service deleted successfully',
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

final class ServiceError extends ServicesState {
  final String message;
  ServiceError(this.message);

  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);
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
      ),
    );
  }
}
