import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/appointments/logic/cubit/case_history_cubit.dart';
import 'package:el_sharq_clinic/features/appointments/ui/widgets/case_history_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainActionButton extends StatelessWidget {
  const MainActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: context.read<CaseHistoryCubit>().showDeleteButtonNotifier,
      builder: (context, child) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: context.read<CaseHistoryCubit>().showDeleteButtonNotifier.value
            ? _buildDeleteCaseButton(context)
            : _buildNewCaseButton(context),
      ),
    );
  }

  AppTextButton _buildNewCaseButton(BuildContext context) {
    return AppTextButton(
      key: const ValueKey('new_case_button'),
      text: 'New Case',
      icon: Icons.book_outlined,
      onPressed: () => showCaseHistoryideSheet(context, 'New Case'),
      width: 200,
    );
  }

  AppTextButton _buildDeleteCaseButton(BuildContext context) {
    return AppTextButton(
      key: const ValueKey('delete_case_button'),
      text: 'Delete',
      icon: Icons.delete,
      color: AppColors.red,
      onPressed: () {
        _showDeleteDialog(context);
      },
      width: 200,
    );
  }

  Future<dynamic> _showDeleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AppAlertDialog(
        alertMessage: 'Are you sure you want to delete these cases?\n'
            'This action cannot be undone.',
        onConfirm: () => context.read<CaseHistoryCubit>().deleteSelectedCases(),
        onCancel: () {},
      ),
    );
  }
}
