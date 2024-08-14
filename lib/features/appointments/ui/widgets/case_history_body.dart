import 'package:el_sharq_clinic/core/widgets/custom_table.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/appointments/logic/cubit/case_history_cubit.dart';
import 'package:el_sharq_clinic/features/appointments/ui/widgets/case_history_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaseHistoryBody extends StatelessWidget {
  const CaseHistoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionDetailsContainer(
      padding: EdgeInsets.zero,
      child: BlocBuilder<CaseHistoryCubit, CaseHistoryState>(
        builder: (context, state) {
          if (state is CaseHistorySuccess) {
            return _buildSuccess(context, state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  CustomTable _buildSuccess(BuildContext context, CaseHistoryState state) {
    return CustomTable(
      onTappableIndexSelected: () =>
          showCaseHistoryideSheet(context, 'Case Details', isNew: false),
      tappableCellIndex: 0,
      fields: const [
        'Case ID',
        'Owner Name',
        'Phone',
        'Pet Name',
        'Date',
        'Actions'
      ],
      rows: [
        ..._getRows(state),
        ..._getRows(state),
        ..._getRows(state),
        ..._getRows(state)
      ],
    );
  }

  List<List<String>> _getRows(CaseHistoryState state) {
    return (state as CaseHistorySuccess).cases.map((caseHistory) {
      return caseHistory.toList();
    }).toList();
  }
}
