import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table_data_source.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/doctors/ui/widgets/doctors_row_action_button.dart';
import 'package:el_sharq_clinic/features/doctors/ui/widgets/doctors_side_sheet.dart';
import 'package:flutter/material.dart';

class DoctorsBody extends StatelessWidget {
  const DoctorsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionDetailsContainer(
      padding: EdgeInsets.zero,
      borderRadius: 10,
      child: _buildChild(context),
    );
  }

  CustomTable _buildChild(BuildContext context) {
    return CustomTable(
      onPageChanged: (firstIndex) {},
      fields: AppConstant.doctorsTableHeaders,
      dataSource: CustomTableDataSource(
        columnsCount: AppConstant.ownersTableHeaders.length,
        data: [
          ['DCR001', 'mario', 'veterinarian', '01000000000', '2024-08-05']
        ],
        actionBuilder: (id) => DoctorsRowActionButton(
          id: id,
        ),
        tappableCellIndex: 0,
        onSelectionChanged: (index, selected) {},
        onTappableCellTap: (id) =>
            showDoctorSheet(context, 'Edit Doctor', editable: false),
        selectedRows: [false],
      ),
    );
  }
}
