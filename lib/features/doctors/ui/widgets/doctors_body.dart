import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table_data_source.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/doctors/data/models/doctor_model.dart';
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
        columnsCount: AppConstant.doctorsTableHeaders.length,
        data: [
          ['DCR001', 'mario', '01000000000', '2024-08-05']
        ],
        actionBuilder: (id) => DoctorsRowActionButton(
          id: id,
        ),
        tappableCellIndex: 0,
        onSelectionChanged: (index, selected) {},
        onTappableCellTap: (id) => showDoctorSheet(
          context,
          'Doctor Details',
          editable: false,
          doctor: DoctorModel(
            id: 'DCR001',
            name: 'mario',
            phoneNumber: '01221826469',
          ),
        ),
        selectedRows: [false],
      ),
    );
  }
}
