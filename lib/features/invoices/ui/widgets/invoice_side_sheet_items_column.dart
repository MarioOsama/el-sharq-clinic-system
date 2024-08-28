import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoice_side_sheet_item_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoiceSideSheetItemsColumn extends StatelessWidget {
  const InvoiceSideSheetItemsColumn({
    super.key,
    required this.editable,
    required this.itemsFormKeys,
    this.onSaved,
  });

  final bool editable;
  final List<GlobalKey<FormState>> itemsFormKeys;
  final void Function(String field, String? value, int itemIndex)? onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _getItems(itemsFormKeys.length),
    );
  }

  List<Widget> _getItems(int numberOfItems) {
    return List.generate(
      numberOfItems,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Stack(
          children: [
            InvoiceSideSheetItemContainer(
              itemType: 'Service',
              index: index + 1,
              itemFormKey: itemsFormKeys[index],
              editable: editable,
              onSaved: (field, value) {
                if (onSaved != null) onSaved!(field, value, index);
              },
            ),
            if (index != 0 && editable) _buildRemoveButton(index),
          ],
        ),
      ),
    );
  }

  Positioned _buildRemoveButton(int index) {
    return Positioned(
      top: 30.h,
      right: 0,
      child: IconButton(
          hoverColor: Colors.transparent,
          icon: const Icon(
            Icons.cancel,
            color: AppColors.red,
            size: 30,
          ),
          onPressed: () {}),
    );
  }
}
