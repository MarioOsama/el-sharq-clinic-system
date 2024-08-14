import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/features/appointments/logic/cubit/case_history_cubit.dart';
import 'package:el_sharq_clinic/features/appointments/ui/widgets/case_history_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaseHistoryTableActionButton extends StatelessWidget {
  const CaseHistoryTableActionButton({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'Edit',
            onTap: () {
              final caseHistoryModel =
                  context.read<CaseHistoryCubit>().getCaseHistoryById(id);
              showCaseHistoryideSheet(context, 'Edit Case',
                  caseHistoryModel: caseHistoryModel);
            },
            child: const Text(
              'Edit',
              style: AppTextStyles.font14DarkGreyMedium,
            ),
          ),
          PopupMenuItem(
            value: 'Delete',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AppAlertDialog(
                  alertMessage: 'Are you sure you want to delete this case?\n'
                      'This action cannot be undone.',
                  onConfirm: () =>
                      context.read<CaseHistoryCubit>().deleteCase(id),
                  onCancel: () {},
                ),
              );
            },
            child: const Text(
              'Delete',
              style: AppTextStyles.font14DarkGreyMedium,
            ),
          ),
        ];
      },
    );
  }
}
