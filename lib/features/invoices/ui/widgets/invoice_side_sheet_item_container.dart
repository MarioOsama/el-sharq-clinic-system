import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_drop_down_menu.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class InvoiceSideSheetItemContainer extends StatelessWidget {
  const InvoiceSideSheetItemContainer(
      {super.key,
      required this.itemType,
      required this.index,
      required this.editable,
      required this.itemFormKey,
      this.onSaved});

  final String itemType;
  final int index;
  final bool editable;
  final GlobalKey<FormState> itemFormKey;
  final void Function(String field, String? value)? onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          index != 0 ? '$itemType $index Details' : '$itemType Details',
          style: AppTextStyles.font16DarkGreyMedium
              .copyWith(color: AppColors.darkGrey.withOpacity(0.5)),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: itemFormKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppDropDownMenu(
                        enabled: editable,
                        hint: '$itemType Name',
                        items: ['Item 1', 'Item 2', 'Item 3'],
                        itemBuilder: (index) => DropdownMenuEntry(
                            value: index.toString(), label: 'Item $index'),
                        onChanged: (value) {},
                      ),
                    ),
                    horizontalSpace(70),
                    Expanded(
                      child: AppTextField(
                        enabled: editable,
                        hint: 'Number of items',
                        validator: (value) {
                          if (value!.isEmpty || int.tryParse(value) == null) {
                            return 'Please enter a valid number of items';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          onSaved?.call('number of items', value);
                        },
                      ),
                    ),
                  ],
                ),
                verticalSpace(20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppTextField(
                        enabled: false,
                        hint: 'Total: ',
                        onSaved: (value) {
                          onSaved?.call('price', value);
                        },
                      ),
                    ),
                    horizontalSpace(65),
                    Expanded(
                      child: AppTextField(
                        enabled: editable,
                        hint: 'Price: ',
                        validator: (value) {
                          if (value!.isEmpty ||
                              double.tryParse(value) == null) {
                            return 'Please enter a valid price';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          onSaved?.call('price', value);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
