import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table_data_source.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/cases/logic/cubit/case_history_cubit.dart';
import 'package:el_sharq_clinic/features/cases/ui/widgets/case_history_action_button.dart';
import 'package:el_sharq_clinic/features/cases/ui/widgets/case_history_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaseHistoryBody extends StatefulWidget {
  const CaseHistoryBody({super.key});

  @override
  State<CaseHistoryBody> createState() => _CaseHistoryBodyState();
}

class _CaseHistoryBodyState extends State<CaseHistoryBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseHistoryCubit, CaseHistoryState>(
      buildWhen: (previous, current) =>
          current is CaseHistorySuccess ||
          current is CaseHistoryError ||
          current is CaseHistoryLoading,
      builder: (context, state) {
        return SectionDetailsContainer(
          padding: EdgeInsets.zero,
          borderRadius: 10,
          color: state is CaseHistorySuccess
              ? AppColors.darkGrey.withOpacity(0.75)
              : AppColors.white,
          child: _buildChild(context, state),
        );
      },
    );
  }

  Widget _buildChild(BuildContext context, CaseHistoryState state) {
    if (state is CaseHistorySuccess) {
      return _buildSuccess(context);
    }
    if (state is CaseHistoryError) {
      return Center(
        child: Text(
          state.errorMessage,
          style: AppTextStyles.font20DarkGreyMedium,
        ),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  CustomTable _buildSuccess(BuildContext context) {
    return CustomTable(
      onPageChanged: (firstIndex) {
        context.read<CaseHistoryCubit>().getNextPage(firstIndex);
      },
      fields: AppConstant.casesTableHeaders,
      dataSource: CustomTableDataSource(
        columnsCount: AppConstant.casesTableHeaders.length,
        data: _getRows(context),
        actionBuilder: (id) => CaseHistoryTableActionButton(
          id: id,
        ),
        tappableCellIndex: 0,
        onSelectionChanged: (index, selected) {
          setState(() {
            context.read<CaseHistoryCubit>().onMultiSelection(index, selected);
          });
        },
        onTappableCellTap: (id) => showCaseSheet(
          context,
          'Case Details',
          editable: false,
          caseHistoryModel:
              context.read<CaseHistoryCubit>().getCaseHistoryById(id),
        ),
        selectedRows: context.read<CaseHistoryCubit>().selectedRows,
      ),
    );
  }

  List<List<String>> _getRows(BuildContext context) {
    return context.watch<CaseHistoryCubit>().casesList.map((caseHistory) {
      return caseHistory!.toList();
    }).toList();
  }
}
