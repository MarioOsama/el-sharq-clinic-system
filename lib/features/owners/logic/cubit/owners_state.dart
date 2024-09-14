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
  final String message;

  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);

    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
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

  OwnersError(this.message);
}

final class OwnersPetsChanged extends OwnersState {
  final int numberOfPets;

  OwnersPetsChanged(this.numberOfPets);
}

// Owner
final class OwnerLoading extends OwnersState {
  @override
  void takeAction(BuildContext context) {
    showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: FadedAnimatedLoadingIcon());
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
      builder: (ctx) => AppDialog(
        title: AppStrings.success.tr(),
        content: AppStrings.newOwnerCreated.tr(),
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

final class OwnerUpdated extends OwnersState {
  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);
    context.pop();
    context.pop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppDialog(
        title: AppStrings.success.tr(),
        content: AppStrings.ownerInfoUpdated.tr(),
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

final class OwnerDeleted extends OwnersState {
  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppDialog(
        title: AppStrings.success.tr(),
        content: AppStrings.ownerProfileDeleted.tr(),
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

final class OwnerError extends OwnersState {
  final String message;

  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);

    context.pop();
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
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

  OwnerError(this.message);
}
