import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionSearchBar extends StatelessWidget {
  const SectionSearchBar(
      {super.key,
      this.controller,
      this.onChanged,
      this.onClear,
      this.hintText});

  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function()? onClear;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500.w,
      height: 50.h,
      decoration: _buildBoxDecoration(),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        cursorHeight: 5.h,
        style: AppTextStyles.font20DarkGreyMedium,
        decoration: _buildInputDecoration(),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 3,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: hintText ?? 'Search',
      prefixIcon: const Icon(Icons.search),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
