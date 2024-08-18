import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class FieldsRow extends StatelessWidget {
  const FieldsRow({
    super.key,
    required this.fields,
    this.firstController,
    this.secondController,
    this.enabled,
    this.firstSuffixIcon,
    this.secondSuffixIcon,
    this.readOnly,
    this.isMultiline,
  });

  final List<String> fields;
  final TextEditingController? firstController;
  final TextEditingController? secondController;
  final Widget? firstSuffixIcon;
  final Widget? secondSuffixIcon;
  final bool? enabled;
  final bool? readOnly;
  final bool? isMultiline;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: firstController,
            hint: fields.first,
            suffixIcon: firstSuffixIcon,
            enabled: enabled,
            readOnly: readOnly,
            isMultiline: isMultiline,
            height: isMultiline ?? false ? 150 : null,
          ),
        ),
        horizontalSpace(50),
        Expanded(
          child: AppTextField(
            controller: secondController,
            hint: fields.last,
            suffixIcon: secondSuffixIcon,
            enabled: enabled,
            readOnly: readOnly,
            isMultiline: isMultiline,
            height: isMultiline ?? false ? 150 : null,
          ),
        ),
      ],
    );
  }
}
