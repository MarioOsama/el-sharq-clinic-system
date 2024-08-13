import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/dashboard_body.dart';
import 'package:flutter/material.dart';

class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key, required AuthDataModel authData});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: 'Dashboard',
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(50),
            const Expanded(child: DashboardBody()),
          ],
        ),
      ),
    );
  }
}
