import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_drop_down_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_drop_down_menu.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_item_model.dart';
import 'package:el_sharq_clinic/features/invoices/logic/cubit/invoices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceSideSheetItemContainer extends StatefulWidget {
  const InvoiceSideSheetItemContainer({
    super.key,
    required this.index,
    required this.editable,
    required this.itemFormKey,
    this.onSaved,
    required this.cubitContext,
  });

  final int index;
  final bool editable;
  final GlobalKey<FormState> itemFormKey;
  final void Function(String field, String? value)? onSaved;
  final BuildContext cubitContext;

  @override
  State<InvoiceSideSheetItemContainer> createState() =>
      _InvoiceSideSheetItemContainerState();
}

class _InvoiceSideSheetItemContainerState
    extends State<InvoiceSideSheetItemContainer> {
  final List<String> itemTypesList = const [
    'Service',
    'Medicines',
    'Accessories'
  ];
  int selectedTypeIndex = 0;
  String itemType = 'Service';
  InvoiceItemModel itemModel = InvoiceItemModel(
    name: '',
    type: 'Service',
    quantity: 0,
    price: 0,
  );

  late TextEditingController totalPriceController;
  late TextEditingController quantityController;
  late TextEditingController itemNameController;
  late InvoicesCubit cubit;
  late List<String> items;

  @override
  void initState() {
    super.initState();
    cubit = widget.cubitContext.read<InvoicesCubit>();
    items = cubit.servicesList.map((e) => e.title).toList();
    totalPriceController = TextEditingController();
    quantityController = TextEditingController();
    itemNameController = TextEditingController();
    totalPriceController.text = '0';
    quantityController.text = '1';
    itemNameController.text = 'Choose $itemType';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.index != 0
              ? 'Item ${widget.index} Details'
              : '$itemType Details',
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
            key: widget.itemFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Item Type',
                  style: AppTextStyles.font16DarkGreyMedium
                      .copyWith(color: AppColors.darkGrey.withOpacity(0.5)),
                ),
                AppDropDownButton(
                  enabled: widget.editable,
                  items: itemTypesList,
                  initialValue: itemTypesList[selectedTypeIndex],
                  width: double.infinity,
                  onChanged: _onTypeChanged,
                ),
                verticalSpace(20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppDropDownMenu(
                        onFocused: () {
                          itemNameController.clear();
                        },
                        controller: itemNameController,
                        enabled: widget.editable,
                        hint: 'Item Name',
                        items: items,
                        onFilter: (entries, filter) =>
                            cubit.onItemSearch(entries, items, filter),
                        onChanged: _onItemNameChanged,
                      ),
                    ),
                    horizontalSpace(70),
                    Expanded(
                      child: AppTextField(
                        controller: quantityController,
                        enabled: widget.editable,
                        hint: 'Number of items',
                        onChanged: _onNumberOfItemsChanged,
                        validator: (value) {
                          if (value!.isEmpty ||
                              double.tryParse(value) == null) {
                            return 'Please enter a valid number of items';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          widget.onSaved?.call('number of items', value);
                        },
                      ),
                    ),
                  ],
                ),
                verticalSpace(20),
                AppTextField(
                  controller: totalPriceController,
                  maxWidth: double.infinity,
                  hint: 'Total: ',
                  readOnly: true,
                  onSaved: (value) {
                    widget.onSaved?.call('total', value);
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onTypeChanged(String? value) {
    switch (value) {
      case 'Service':
        items = cubit.servicesList.map((e) => e.title).toList();
        selectedTypeIndex = itemTypesList.indexOf(value!);
        itemType = 'Service';
        _resetControllers();
        break;
      case 'Medicines':
        items = cubit.medicinesList.map((e) => e.title).toList();
        selectedTypeIndex = itemTypesList.indexOf(value!);
        itemType = 'Medicines';
        _resetControllers();
        break;
      case 'Accessories':
        items = cubit.accessoriesList.map((e) => e.title).toList();
        selectedTypeIndex = itemTypesList.indexOf(value!);
        itemType = 'Accessories';
        _resetControllers();
        break;

      default:
        items = cubit.servicesList.map((e) => e.title).toList();
        selectedTypeIndex = itemTypesList.indexOf('Service');
        itemType = 'Service';
        _resetControllers();
        break;
    }
    setState(() {});
  }

  void _resetControllers() {
    totalPriceController.text = '0';
    quantityController.text = '1';
    itemNameController.text = 'Choose $itemType';
  }

  void _onNumberOfItemsChanged(String value) {
    if (value.isEmpty ||
        double.tryParse(value) == null ||
        double.tryParse(value)! < 0) {
      return;
    }
    quantityController.text = value;
    totalPriceController.text =
        (double.parse(value) * itemModel.price).toString();
  }

  void _onItemNameChanged(String? value) {
    cubit.onItemSelected(value, itemType, widget.index);
    itemModel = cubit.itemsList[widget.index - 1];
    totalPriceController.text =
        (itemModel.quantity * itemModel.price).toString();
    quantityController.text = '1';
  }

  @override
  void dispose() {
    totalPriceController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}
