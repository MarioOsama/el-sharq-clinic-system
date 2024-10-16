part of 'cases_cubit.dart';

abstract class CasesState {
  void takeAction(BuildContext context) {}
}

final class CasesInitial extends CasesState {}

final class CasesLoading extends CasesState {}

final class CasesSuccess extends CasesState {
  final List<CaseHistoryModel?> cases;

  CasesSuccess({required this.cases});
}

final class CasesError extends CasesState {
  final String errorMessage;

  CasesError(this.errorMessage);

  @override
  void takeAction(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AppDialog(
              title: AppStrings.error.tr(),
              content: errorMessage,
              dialogType: DialogType.error,
              action: AppTextButton(
                text: AppStrings.ok.tr(),
                onPressed: () => context.pop(),
                filled: false,
              ),
            ));
  }
}

final class CasesSearching extends CasesState {
  final List<CaseHistoryModel?> cases;

  CasesSearching({required this.cases});
}

// CaseHistory
final class NewCaseHistoryInvalid extends CasesState {
  final String? title;
  final String errorMessage;

  NewCaseHistoryInvalid(this.errorMessage, {this.title});

  @override
  void takeAction(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AppDialog(
              title: title ?? AppStrings.error.tr(),
              content: errorMessage,
              dialogType: DialogType.error,
              action: AppTextButton(
                text: AppStrings.ok.tr(),
                onPressed: () => context.pop(),
                filled: false,
              ),
            ));
  }
}

final class NewCaseLoading extends CasesState {
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

final class NewCaseSuccess extends CasesState {
  @override
  void takeAction(BuildContext context) {
    // Hide loading dialog
    context.pop();
    // Hide side sheet
    context.pop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppDialog(
        title: AppStrings.success.tr(),
        content: AppStrings.newCaseCreated.tr(),
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

final class NewCaseFailure extends CasesState {
  final String errorMessage;

  NewCaseFailure(this.errorMessage);

  @override
  void takeAction(BuildContext context) {
    context.pop();

    showDialog(
        context: context,
        builder: (ctx) => AppDialog(
              title: AppStrings.error.tr(),
              content: errorMessage,
              dialogType: DialogType.error,
              action: AppTextButton(
                text: AppStrings.ok.tr(),
                onPressed: () => context.pop(),
                filled: false,
              ),
            ));
  }
}

final class UpdateCaseSuccess extends CasesState {
  @override
  void takeAction(BuildContext context) {
    context.pop();

    context.pop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppDialog(
        title: AppStrings.success.tr(),
        content: AppStrings.caseUpdated.tr(),
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

final class DeleteCaseSuccess extends CasesState {
  @override
  void takeAction(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppDialog(
        title: AppStrings.success.tr(),
        content: AppStrings.casesDeleted.tr(),
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
