import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/fields_row.dart';
import 'package:flutter/material.dart';

class SideSheetOwnerContainer extends StatelessWidget {
  const SideSheetOwnerContainer({
    super.key,
    required this.editable,
    required this.ownerFormKey,
  });

  final bool editable;
  final GlobalKey<FormState> ownerFormKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Owner Info',
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
            key: ownerFormKey,
            child: FieldsRow(
              fields: const [
                'Name',
                'Phone',
              ],
              validations: const [true, true],
              enabled: editable,
            ),
          ),
        ),
      ],
    );
  }
}
