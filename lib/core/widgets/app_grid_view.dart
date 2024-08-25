import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppGridView extends StatelessWidget {
  const AppGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio,
  });

  final int itemCount;
  final Widget? Function(BuildContext ctx, int index) itemBuilder;
  final int? crossAxisCount;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final double? childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount,
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount ?? 3,
        mainAxisSpacing: mainAxisSpacing ?? 50.h,
        crossAxisSpacing: crossAxisSpacing ?? 50.w,
        childAspectRatio: childAspectRatio ?? 3,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
