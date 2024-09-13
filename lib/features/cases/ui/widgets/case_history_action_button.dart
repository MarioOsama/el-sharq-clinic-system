import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/features/cases/logic/cubit/case_history_cubit.dart';
import 'package:el_sharq_clinic/features/cases/ui/widgets/case_history_side_sheet.dart';
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
      itemBuilder: (ctx) {
        return [
          PopupMenuItem(
            value: AppStrings.edit.tr(),
            onTap: () {
              final caseHistoryModel =
                  context.read<CaseHistoryCubit>().getCaseHistoryById(id);
              showCaseSheet(context, AppStrings.editCase.tr(),
                  caseHistoryModel: caseHistoryModel);
            },
            child: Text(
              AppStrings.edit.tr(),
              style: AppTextStyles.font14DarkGreyMedium(context),
            ),
          ),
          PopupMenuItem(
            value: AppStrings.delete.tr(),
            onTap: () {
              showDialog(
                context: ctx,
                builder: (_) => AppAlertDialog(
                  alertMessage: AppStrings.deleteCaseMessage.tr(),
                  onConfirm: () {
                    context.read<CaseHistoryCubit>().deleteCase(id);
                    ctx.pop();
                  },
                  onCancel: () {
                    ctx.pop();
                  },
                ),
              );
            },
            child: Text(
              AppStrings.delete.tr(),
              style: AppTextStyles.font14DarkGreyMedium(context),
            ),
          ),
        ];
      },
    );
  }
}
