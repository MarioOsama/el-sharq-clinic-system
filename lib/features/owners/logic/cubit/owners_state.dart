part of 'owners_cubit.dart';

abstract class OwnersState {
  void takeAction(BuildContext context) {}
}

final class OwnersInitial extends OwnersState {}

final class OwnersLoading extends OwnersState {}

final class OwnersSuccess extends OwnersState {
  final List<OwnerModel?> owners;

  OwnersSuccess({required this.owners});
}

final class OwnersError extends OwnersState {
  final String errorMessage;

  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);
    context.pop();

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
      ),
    );
  }

  OwnersError(this.errorMessage);
}

final class OwnersPetsChanged extends OwnersState {
  final int numberOfPets;

  OwnersPetsChanged(this.numberOfPets);
}

// Owner
final class NewOwnerLoading extends OwnersState {
  @override
  void takeAction(BuildContext context) {
    showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
  }
}

final class NewOwnerAdded extends OwnersState {
  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);
    // Hide loading dialog
    context.pop();
    // Hide side sheet
    context.pop();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => const AppDialog(
        title: 'Success',
        content: 'New owner profile created successfully',
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

final class OwnerUpdated extends OwnersState {}

final class OwnerDeleted extends OwnersState {}
