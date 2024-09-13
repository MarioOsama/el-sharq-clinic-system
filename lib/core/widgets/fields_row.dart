import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class FieldsRow extends StatelessWidget {
  /// A row of fields.
  ///
  /// This widget represents a row of fields that can be used in forms or data entry screens.
  /// It is a stateless widget, meaning it does not hold any mutable state.
  /// Use this widget to display a row of two fields in your application.
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
    this.validations = const [true, true],
    this.firstText,
    this.secondText,
    this.onSaved,
    this.firstValidator,
    this.secondValidator,
  });

  /// Fields[0] for first field, fields[1] for second field
  final List<String> fields;
  final TextEditingController? firstController;
  final TextEditingController? secondController;
  final String? firstText;
  final String? secondText;

  /// FirstSuffixIcon is an icon for first field
  final Widget? firstSuffixIcon;

  /// SecondSuffixIcon is an icon for second field
  final Widget? secondSuffixIcon;
  final bool? enabled;
  final bool? readOnly;
  final bool? isMultiline;

  /// validations[0] for first field, validations[1] for second field
  final List<bool>? validations;

  final void Function(String field, String? value)? onSaved;

  final String? Function(String? value)? firstValidator;
  final String? Function(String? value)? secondValidator;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            initialValue: firstText,
            validator: validations!.first
                ? (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please enter a ${fields.first}';
                    }
                    if (firstValidator != null) {
                      return firstValidator?.call(value);
                    }
                    return null;
                  }
                : null,
            onSaved: (value) {
              if (onSaved != null) {
                onSaved!(fields.first, value);
              }
            },
            controller: firstController,
            hint: fields.first.tr(),
            suffixIcon: firstSuffixIcon,
            enabled: enabled,
            readOnly: readOnly,
            isMultiline: isMultiline,
          ),
        ),
        horizontalSpace(50),
        Expanded(
          child: AppTextField(
            initialValue: secondText,
            validator: validations!.last
                ? (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please enter a ${fields.last}';
                    }
                    if (secondValidator != null) {
                      return secondValidator?.call(value);
                    }
                    return null;
                  }
                : null,
            onSaved: (value) {
              if (onSaved != null) {
                onSaved!(fields.last, value);
              }
            },
            controller: secondController,
            hint: fields.last.tr(),
            suffixIcon: secondSuffixIcon,
            enabled: enabled,
            readOnly: readOnly,
            isMultiline: isMultiline,
          ),
        ),
      ],
    );
  }
}
