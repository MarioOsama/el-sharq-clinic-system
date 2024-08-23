import 'package:el_sharq_clinic/features/services/ui/widgets/service_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesGridView extends StatelessWidget {
  const ServicesGridView({
    super.key,
    required this.items,
  });

  final List items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 50.h,
        crossAxisSpacing: 50.w,
        childAspectRatio: 3,
      ),
      itemBuilder: (context, index) => ServiceItem(
        title: 'title $index',
        price: 'price $index',
      ),
    );
  }
}
