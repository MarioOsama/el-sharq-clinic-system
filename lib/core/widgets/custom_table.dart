import 'package:data_table_2/data_table_2.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTable extends StatefulWidget {
  const CustomTable({
    super.key,
    required this.fields,
    required this.rows,
    this.onTappableIndexSelected,
    this.tappableCellIndex = -1,
    required this.actionButton,
    required this.onMultiSelection,
  });

  final List<String> fields;
  final List rows;
  final void Function(String id)? onTappableIndexSelected;
  final int? tappableCellIndex;
  final Widget Function(String id) actionButton;
  final void Function(List<bool> selectedItems) onMultiSelection;

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  late List<bool> _selectedRows;

  @override
  void initState() {
    super.initState();
    // Initialize the selection state for each row
    _selectedRows = List<bool>.filled(widget.rows.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: DataTable2(
        headingRowColor: const WidgetStatePropertyAll(AppColors.grey),
        columns: _buildTableColumns,
        rows: _buildTableRows(
            context, widget.onTappableIndexSelected, widget.tappableCellIndex!),
      ),
    );
  }

  List<DataColumn> get _buildTableColumns =>
      List.generate(widget.fields.length, (index) {
        return DataColumn(
            label: Text(widget.fields[index],
                style: AppTextStyles.font20DarkGreyMedium));
      });

  List<DataRow> _buildTableRows(BuildContext context,
          Function(String)? onCellSelected, int tappableCellIndex) =>
      List.generate(widget.rows.length, (index) {
        return DataRow(
          onSelectChanged: (bool? selected) {
            setState(() {
              _selectedRows[index] = selected ?? false;
            });
            if (_selectedRows.any((element) => element)) {
              widget.onMultiSelection(_selectedRows);
            } else {
              widget.onMultiSelection(_selectedRows);
            }
          },
          selected: _selectedRows[index],
          cells: List.generate(widget.fields.length, (cellIndex) {
            if (widget.fields[cellIndex] == 'Actions') {
              return _buildEditMenuButton(widget.rows[index][0]);
            }
            if (cellIndex == tappableCellIndex) {
              return _buildTappableCell(
                  context, index, cellIndex, onCellSelected);
            }
            return DataCell(
              Text(
                widget.rows[index][cellIndex],
                style: AppTextStyles.font16DarkGreyMedium,
              ),
            );
          }),
        );
      });

  DataCell _buildTappableCell(BuildContext context, int index, int cellIndex,
      Function(String)? onCellSelected) {
    return DataCell(
      onTap: () {
        if (onCellSelected != null) {
          onCellSelected(widget.rows[index][0]);
        }
      },
      Text(
        widget.rows[index][cellIndex],
        style: AppTextStyles.font16DarkGreyMedium,
      ),
    );
  }

  DataCell _buildEditMenuButton(String id) {
    return DataCell(
      widget.actionButton(id),
    );
  }
}
