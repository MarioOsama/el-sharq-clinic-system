import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/core/widgets/section_search_bar.dart';
import 'package:el_sharq_clinic/features/cases/logic/cubit/case_history_cubit.dart';
import 'package:el_sharq_clinic/features/cases/ui/widgets/case_history_bloc_listener.dart';
import 'package:el_sharq_clinic/features/cases/ui/widgets/case_history_body.dart';
import 'package:el_sharq_clinic/features/cases/ui/widgets/case_history_side_sheet.dart';
import 'package:el_sharq_clinic/core/widgets/section_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaseHistorySection extends StatelessWidget {
  const CaseHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: AppStrings.casesHistory.tr(),
      actions: [
        // Search bar
        SectionSearchBar(
          hintText: AppStrings.casesSearchText.tr(),
          onChanged: (value) {
            context.read<CaseHistoryCubit>().onSearch(value);
          },
        ),

        SectionActionButton(
          newText: AppStrings.newCase.tr(),
          onNewPressed: () => showCaseSheet(context, AppStrings.newCase.tr()),
          onDeletePressed: () => _showDeleteDialog(context),
          valueNotifier:
              context.read<CaseHistoryCubit>().showDeleteButtonNotifier,
        ),
      ],
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(50),
            const Expanded(child: CaseHistoryBody()),
            const CaseHistoryBlocListener(),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showDeleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AppAlertDialog(
        alertMessage: AppStrings.deleteCaseMessage,
        onConfirm: () {
          context.read<CaseHistoryCubit>().deleteSelectedCases();
          context.pop();
        },
        onCancel: () {
          ctx.pop();
        },
      ),
    );
  }
}
