import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/custom_side_sheet.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showProductSheet(BuildContext context, String title,
    {bool editable = true}) async {
  await showCustomSideSheet(
    context: context,
    scrollable: false,
    child: Column(children: [
      SectionTitle(title: title),
      verticalSpace(50),
      Row(
        children: [
          Expanded(
            flex: 4,
            child: AppTextField(
              hint: 'Product Name',
              enabled: editable,
              maxWidth: double.infinity,
            ),
          ),
          horizontalSpace(20),
          Expanded(
            child: AppTextField(
              hint: 'Price',
              enabled: editable,
            ),
          ),
        ],
      ),
      verticalSpace(50),
      AppTextField(
        hint: 'Description',
        enabled: editable,
        isMultiline: true,
        maxWidth: double.infinity,
      ),
      const Spacer(),
      // _buildActionIfNeeded(context, editable),
      _buildNewAction(context),
    ]),
  );
}

// _buildActionIfNeeded(BuildContext context,
//     bool editMode) {
//   if (newService) {
//     return _buildNewAction(context);
//   } else if (editMode) {
//     return _buildUpdateAction(context);
//   }
//   return const SizedBox.shrink();
// }

AppTextButton _buildNewAction(BuildContext context) {
  return AppTextButton(
    text: 'Save Product',
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {},
  );
}

AppTextButton _buildUpdateAction(BuildContext context) {
  return AppTextButton(
    text: 'Update Product',
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {},
  );
}
