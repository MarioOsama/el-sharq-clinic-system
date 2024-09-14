part of 'case_history_cubit.dart';

abstract class CaseHistoryState {
  void takeAction(BuildContext context);
}

final class CasesInitial implements CaseHistoryState {
  @override
  void takeAction(BuildContext context) {}
}

final class CasesLoading extends CaseHistoryState {
  @override
  void takeAction(BuildContext context) {}
}

final class CasesSuccess extends CaseHistoryState {
  final List<CaseHistoryModel?> cases;

  CasesSuccess({required this.cases});

  @override
  void takeAction(BuildContext context) {}
}

final class CasesError extends CaseHistoryState {
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

// CaseHistory
final class NewCaseHistoryInvalid extends CaseHistoryState {
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

final class NewCaseHistoryLoading extends CaseHistoryState {
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

final class NewCaseHistorySuccess extends CaseHistoryState {
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

final class NewCaseHistoryFailure extends CaseHistoryState {
  final String errorMessage;

  NewCaseHistoryFailure(this.errorMessage);

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

final class UpdateCaseHistorySuccess extends CaseHistoryState {
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

final class DeleteCaseHistorySuccess extends CaseHistoryState {
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
