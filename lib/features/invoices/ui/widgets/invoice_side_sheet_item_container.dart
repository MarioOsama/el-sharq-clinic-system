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
    required this.cubitContext,
    this.invoiceItem,
  });

  final int index;
  final bool editable;
  final GlobalKey<FormState> itemFormKey;
  final BuildContext cubitContext;
  final InvoiceItemModel? invoiceItem;

  @override
  State<InvoiceSideSheetItemContainer> createState() =>
      _InvoiceSideSheetItemContainerState();
}

class _InvoiceSideSheetItemContainerState
    extends State<InvoiceSideSheetItemContainer> {
  final List<String> itemTypesList = const [
    'Services',
    'Medicines',
    'Accessories'
  ];
  int selectedTypeIndex = 0;
  String itemType = 'Services';
  InvoiceItemModel itemModel = InvoiceItemModel(
    name: '',
    type: 'Services',
    quantity: 0,
    price: 0,
  );

  late TextEditingController priceController;
  late TextEditingController totalPriceController;
  late TextEditingController quantityController;
  late TextEditingController itemNameController;

  late InvoicesCubit cubit;
  late List<String> items;

  @override
  void initState() {
    super.initState();
    _setupControllers();
    if (widget.invoiceItem != null) {
      _setupExistingItem();
    } else {
      _setupNewItem();
    }
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
          style: AppTextStyles.font16DarkGreyMedium(context)
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
                  style: AppTextStyles.font16DarkGreyMedium(context)
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
                        onFilter: widget.editable
                            ? (entries, filter) =>
                                cubit.onItemSearch(entries, items, filter)
                            : null,
                        onChanged: widget.editable ? _onItemNameChanged : null,
                      ),
                    ),
                    horizontalSpace(70),
                    Expanded(
                      child: AppTextField(
                        controller: quantityController,
                        enabled: widget.editable,
                        hint: 'Quantity',
                        onChanged:
                            widget.editable ? _onNumberOfItemsChanged : null,
                        numeric: true,
                        validator: (value) {
                          if (quantityController.text == '0') {
                            return 'Quantity cannot be 0';
                          }
                          return null;
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
                        enabled: widget.editable,
                        controller: totalPriceController,
                        maxWidth: double.infinity,
                        readOnly: true,
                        hint: 'Total: ',
                      ),
                    ),
                    horizontalSpace(70),
                    Expanded(
                      child: AppTextField(
                        controller: priceController,
                        enabled: widget.editable,
                        hint: 'Price',
                        readOnly: true,
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

  void _onTypeChanged(String? value) {
    cubit.onResetInvoiceItem(widget.index - 1);
    switch (value) {
      case 'Services':
        items = cubit.servicesList.map((e) => e.title).toList();
        selectedTypeIndex = itemTypesList.indexOf(value!);
        itemType = 'Services';
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
        selectedTypeIndex = itemTypesList.indexOf('Services');
        itemType = 'Services';
        _resetControllers();
        break;
    }
    setState(() {});
  }

  void _setupControllers() {
    priceController = TextEditingController();
    totalPriceController = TextEditingController();
    quantityController = TextEditingController();
    itemNameController = TextEditingController();
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
      quantityController.text = '0';
      return;
    }
    if (RegExp(r'^0').hasMatch(value)) {
      quantityController.text = value.substring(1);
    } else {
      quantityController.text = value;
    }

    totalPriceController.text =
        (double.parse(value) * itemModel.price).toString();
    cubit.updateItemQuantity(widget.index - 1, double.parse(value));
  }

  void _onItemNameChanged(String? value) {
    cubit.onItemSelected(value, itemType, widget.index - 1);
    itemModel = cubit.itemsList[widget.index - 1];
    priceController.text = itemModel.price.toString();
    totalPriceController.text =
        (itemModel.quantity * itemModel.price).toString();
    quantityController.text = '1';
  }

  void _setupExistingItem() {
    itemModel = widget.invoiceItem!;
    items = [itemModel.name];
    priceController.text = itemModel.price.toString();
    totalPriceController.text =
        (itemModel.price * itemModel.quantity).toString();
    quantityController.text = itemModel.quantity.toString();
    itemNameController.text = itemModel.name;
    itemType = itemModel.type;
    selectedTypeIndex = itemTypesList.indexOf(itemType);
  }

  void _setupNewItem() {
    cubit = widget.cubitContext.read<InvoicesCubit>();
    items = cubit.servicesList.map((e) => e.title).toList();
    priceController.text = '0';
    totalPriceController.text = '0';
    quantityController.text = '1';
    itemNameController.text = 'Choose $itemType';
  }

  @override
  void dispose() {
    totalPriceController.dispose();
    quantityController.dispose();
    itemNameController.dispose();
    super.dispose();
  }
}
