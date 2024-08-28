import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table_data_source.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoices_row_action_button.dart';
import 'package:flutter/material.dart';

class InvoicesBody extends StatefulWidget {
  const InvoicesBody({super.key});

  @override
  State<InvoicesBody> createState() => _InvoicesBodyState();
}

class _InvoicesBodyState extends State<InvoicesBody> {
  @override
  Widget build(BuildContext context) {
    return SectionDetailsContainer(
      color: AppColors.darkGrey.withOpacity(0.75),
      child: CustomTable(
        onPageChanged: (firstIndex) {},
        fields: AppConstant.invoicesTableHeaders,
        dataSource: CustomTableDataSource(
          columnsCount: AppConstant.doctorsTableHeaders.length,
          data: [],
          actionBuilder: (id) => InvoicesRowActionButton(
            id: id,
          ),
          tappableCellIndex: 0,
          onSelectionChanged: (index, selected) {},
          onTappableCellTap: (id) {},
          selectedRows: [],
        ),
      ),
    );
  }
}
