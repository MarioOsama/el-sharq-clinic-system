import 'package:el_sharq_clinic/core/widgets/custom_table.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/appointments/ui/widgets/case_history_side_sheet.dart';
import 'package:flutter/material.dart';

class CaseHistoryBody extends StatelessWidget {
  const CaseHistoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionDetailsContainer(
      padding: EdgeInsets.zero,
      child: CustomTable(
        onTappableIndexSelected: () => showCaseHistoryideSheet(
            context, 'Appointment Details',
            isNew: false),
        tappableCellIndex: 0,
        fields: [
          'Case ID',
          'Pet Name',
          'Owner Name',
          'Date',
          'Time',
          'Actions'
        ],
        rows: [
          ['1', 'Tom', 'Jerry', '12/12/2021', '12:00', 'Edit'],
          ['2', 'Tom', 'Jerry', '12/12/2021', '12:00', 'Edit'],
          ['3', 'Tom', 'Jerry', '12/12/2021', '12:00', 'Edit'],
        ],
      ),

      // child: Table(
      //   border: TableBorder(
      //     horizontalInside: BorderSide(
      //       color: Colors.grey,
      //       style: BorderStyle.solid,
      //       width: 1.0,
      //     ),
      //   ),
      //   children: [
      //     TableRow(
      //       decoration: BoxDecoration(
      //         color: Colors.grey[200],
      //       ),
      //       children: [
      //         Text(
      //           'Name',
      //           style: AppTextStyles.font20DarkGreyMedium,
      //         ),
      //         Text(
      //           'Date',
      //           style: AppTextStyles.font20DarkGreyMedium,
      //         ),
      //         Text(
      //           'Time',
      //           style: AppTextStyles.font20DarkGreyMedium,
      //         ),
      //         Text(
      //           'Action',
      //           style: AppTextStyles.font20DarkGreyMedium,
      //         ),
      //       ],
      //     ),
      //     TableRow(
      //       children: [
      //         Text('Ahmed'),
      //         Text('12/12/2021'),
      //         Text('12:00'),
      //         Text('Edit'),
      //       ],
      //     ),
      //     TableRow(
      //       children: [
      //         Text('Mohamed'),
      //         Text('12/12/2021'),
      //         Text('12:00'),
      //         Text('Edit'),
      //       ],
      //     ),
      //     TableRow(
      //       children: [
      //         Text('Ali'),
      //         Text('12/12/2021'),
      //         Text('12:00'),
      //         Text('Edit'),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
