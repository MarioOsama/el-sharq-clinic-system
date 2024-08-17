import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomTableDataSource extends DataTableSource {
  final List data;
  final int columnsCount;
  final Widget Function(String id) actionBuilder;
  final int tappableCellIndex;
  final Function(int index, bool selected) onSelectionChanged;
  final Function(String id) onTappableCellTap;
  final List<bool> selectedRows;

  CustomTableDataSource({
    required this.columnsCount,
    required this.data,
    required this.actionBuilder,
    required this.tappableCellIndex,
    required this.onSelectionChanged,
    required this.onTappableCellTap,
    required this.selectedRows,
  });

  @override
  DataRow? getRow(int index) {
    return DataRow(
      onSelectChanged: (bool? selected) {
        onSelectionChanged(index, selected ?? false);
      },
      selected: selectedRows[index],
      cells: List.generate(columnsCount, (cellIndex) {
        if (cellIndex == columnsCount - 1) {
          return _buildEditMenuButton(data[index][0]);
        }
        if (cellIndex == tappableCellIndex) {
          return _buildTappableCell(index, cellIndex, onTappableCellTap);
        }
        return DataCell(
          Text(
            data[index][cellIndex],
            style: AppTextStyles.font16DarkGreyMedium,
          ),
        );
      }),
    );
  }

  DataCell _buildTappableCell(
      int index, int cellIndex, Function(String)? onCellSelected) {
    return DataCell(
      onTap: () {
        if (onCellSelected != null) {
          onCellSelected(data[index][0]);
        }
      },
      Text(
        data[index][cellIndex],
        style: AppTextStyles.font16DarkGreyMedium,
      ),
    );
  }

  DataCell _buildEditMenuButton(String id) {
    return DataCell(
      actionBuilder(id),
    );
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
