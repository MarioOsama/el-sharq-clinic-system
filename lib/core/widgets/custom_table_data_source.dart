import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTableDataSource extends DataTableSource {
  final List<List> data;
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
          // Return the edit menu button with the id of the data row
          return _buildEditMenuButton(data[index][0]);
        }
        if (cellIndex == tappableCellIndex) {
          return _buildTappableCell(index, cellIndex, onTappableCellTap);
        }
        return DataCell(
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              data[index][cellIndex],
              style: font16DarkGreyMedium(),
            ),
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
        style: font16DarkGreyMedium(),
      ),
    );
  }

  DataCell _buildEditMenuButton(String id) {
    return DataCell(
      Align(
          alignment: AlignmentDirectional.centerEnd, child: actionBuilder(id)),
    );
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  static TextStyle font16DarkGreyMedium() => const TextStyle(
        fontSize: 18,
        color: AppColors.darkGrey,
        fontWeight: FontWeight.w500,
        fontFamily: 'Outfit',
      );
}
