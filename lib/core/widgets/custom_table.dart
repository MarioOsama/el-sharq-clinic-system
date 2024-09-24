import 'package:data_table_2/data_table_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({
    super.key,
    required this.fields,
    required this.dataSource,
    required this.onPageChanged,
  });

  final List<String> fields;
  final CustomTableDataSource dataSource;
  final void Function(int firstIndex) onPageChanged;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: PaginatedDataTable2(
        columnSpacing: 10,
        headingRowHeight: 70.h,
        dividerThickness: 0.5,
        autoRowsToHeight: true,
        columns: _buildTableColumns(context),
        horizontalMargin: 15,
        source: dataSource,
        dataRowHeight: height * 0.075,
        headingRowColor:
            const WidgetStatePropertyAll(Color.fromARGB(255, 230, 230, 230)),
        onPageChanged: onPageChanged,
      ),
    );
  }

  List<DataColumn> _buildTableColumns(BuildContext context) =>
      List.generate(fields.length, (index) {
        return DataColumn(
            label: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(fields[index].tr(),
                    style: AppTextStyles.font20DarkGreyMedium(context)
                        .copyWith(fontWeight: FontWeight.bold))));
      });
}
