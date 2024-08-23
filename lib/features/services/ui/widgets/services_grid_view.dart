import 'package:el_sharq_clinic/features/services/data/models/service_model.dart';
import 'package:el_sharq_clinic/features/services/ui/widgets/service_item.dart';
import 'package:el_sharq_clinic/features/services/ui/widgets/services_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesGridView extends StatelessWidget {
  const ServicesGridView({
    super.key,
    required this.items,
  });

  final List<ServiceModel> items;

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
        service: items[index],
        onTap: () => showServiceSheet(
          context,
          'Service Details',
          service: items[index],
          editable: false,
        ),
      ),
    );
  }
}
