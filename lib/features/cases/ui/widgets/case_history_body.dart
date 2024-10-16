import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/faded_animated_loading_icon.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table_data_source.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/cases/logic/cubit/cases_cubit.dart';
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
    return BlocBuilder<CasesCubit, CasesState>(
      buildWhen: (previous, current) =>
          current is CasesSuccess ||
          current is CasesError ||
          current is CasesLoading ||
          current is CasesSearching,
      builder: (context, state) {
        return SectionDetailsContainer(
          color: state is CasesSuccess ? AppColors.lightBlue : AppColors.white,
          child: _buildChild(context, state),
        );
      },
    );
  }

  Widget _buildChild(BuildContext context, CasesState state) {
    if (state is CasesSuccess || state is CasesSearching) {
      return _buildSuccess(context, state);
    }
    if (state is CasesError) {
      return _buildError(state, context);
    }

    return _buildLoading();
  }

  Center _buildLoading() => const Center(child: FadedAnimatedLoadingIcon());

  Center _buildError(CasesError state, BuildContext context) {
    return Center(
      child: Text(
        state.errorMessage,
        style: AppTextStyles.font20DarkGreyMedium(context),
      ),
    );
  }

  CustomTable _buildSuccess(BuildContext context, CasesState state) {
    return CustomTable(
      onPageChanged: (firstIndex) {
        context.read<CasesCubit>().getNextPage(firstIndex);
      },
      fields: AppConstant.casesTableHeaders,
      dataSource: CustomTableDataSource(
        columnsCount: AppConstant.casesTableHeaders.length,
        data: _getRows(state),
        actionBuilder: (id) => CaseHistoryTableActionButton(
          id: id,
        ),
        tappableCellIndex: 0,
        onSelectionChanged: (index, selected) {
          setState(() {
            context.read<CasesCubit>().onMultiSelection(index, selected);
          });
        },
        onTappableCellTap: (id) => showCaseSheet(
          context,
          AppStrings.caseDetails.tr(),
          editable: false,
          caseHistoryModel: context.read<CasesCubit>().getCaseHistoryById(id),
        ),
        selectedRows: context.read<CasesCubit>().selectedRows,
      ),
    );
  }

  List<List<String>> _getRows(CasesState state) {
    if (state is CasesSuccess) {
      return state.cases.map((caseHistory) {
        return caseHistory!.toList();
      }).toList();
    }
    if (state is CasesSearching) {
      return state.cases.map((caseHistory) {
        return caseHistory!.toList();
      }).toList();
    }
    return [];
  }
}
