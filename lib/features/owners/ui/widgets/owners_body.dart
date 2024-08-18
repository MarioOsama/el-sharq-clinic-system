import 'dart:developer';

import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table_data_source.dart';
import 'package:el_sharq_clinic/features/cases/ui/widgets/case_history_action_button.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/owners_row_action_button.dart';
import 'package:flutter/material.dart';

class OwnersBody extends StatelessWidget {
  const OwnersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTable(
      onPageChanged: (firstIndex) {
        // context.read<OwnersCubitCubit>().getNextPage(firstIndex);
      },
      fields: AppConstant.ownersTableHeaders,
      dataSource: CustomTableDataSource(
        columnsCount: AppConstant.casesTableHeaders.length,
        data: _getRows(context),
        actionBuilder: (id) => OwnersRowActionButton(
          id: id,
        ),
        tappableCellIndex: 0,
        onSelectionChanged: (index, selected) {
          // setState(() {
          //   context.read<OwnersCubitCubit>().onMultiSelection(index, selected);
          // });
        },
        onTappableCellTap: (id) => log('Tapped on case id: $id'),
        selectedRows: [],
        // selectedRows: context.read<OwnersCubitCubit>().selectedRows,
      ),
    );
  }

  _getRows(BuildContext context) {
    return [];
  }
}
