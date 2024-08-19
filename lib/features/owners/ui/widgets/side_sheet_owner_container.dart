import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/fields_row.dart';
import 'package:el_sharq_clinic/features/owners/data/local/models/owner_model.dart';
import 'package:flutter/material.dart';

class SideSheetOwnerContainer extends StatelessWidget {
  const SideSheetOwnerContainer({
    super.key,
    required this.editable,
    required this.ownerFormKey,
    this.ownerModel,
    this.onSaved,
  });

  final bool editable;
  final GlobalKey<FormState> ownerFormKey;
  final OwnerModel? ownerModel;
  final void Function(String field, String? value)? onSaved;

  @override
  Widget build(BuildContext context) {
    final bool withOwner = ownerModel != null;
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
              onSaved: onSaved,
              firstText: withOwner ? ownerModel!.name : null,
              secondText: withOwner ? ownerModel!.phone : null,
              validations: const [true, true],
              enabled: editable,
            ),
          ),
        ),
      ],
    );
  }
}
