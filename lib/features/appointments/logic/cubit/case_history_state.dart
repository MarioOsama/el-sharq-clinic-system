part of 'case_history_cubit.dart';

abstract class CaseHistoryState {
  void takeAction(BuildContext context);
}

final class CaseHistoryInitial implements CaseHistoryState {
  @override
  void takeAction(BuildContext context) {}
}

final class CaseHistoryLoading extends CaseHistoryState {
  @override
  void takeAction(BuildContext context) {}
}

final class CaseHistorySuccess extends CaseHistoryState {
  @override
  void takeAction(BuildContext context) {}
}

final class CaseHistoryError extends CaseHistoryState {
  final String errorMessage;

  CaseHistoryError(this.errorMessage);

  @override
  void takeAction(BuildContext context) {
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
            ));
  }
}

// New CaseHistory
final class NewCaseHistoryInvalid extends CaseHistoryState {
  final String? title;
  final String errorMessage;

  NewCaseHistoryInvalid(this.errorMessage, {this.title});

  @override
  void takeAction(BuildContext context) {
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

final class NewCaseHistoryLoading extends CaseHistoryState {
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

final class NewCaseHistorySuccess extends CaseHistoryState {
  @override
  void takeAction(BuildContext context) {
    context.pop();

    context.pop();

    showDialog(
      context: context,
      builder: (ctx) => const AppDialog(
        title: 'Success',
        content: 'New case created successfully',
        dialogType: DialogType.success,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () => context.pop());
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
