import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/features/appointments/ui/widgets/appoinments_body.dart';
import 'package:el_sharq_clinic/features/appointments/ui/widgets/appointment_side_sheet.dart';
import 'package:flutter/material.dart';

class AppoinmentsSection extends StatelessWidget {
  const AppoinmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: 'Appoinments',
      actions: [
        AppTextButton(
          text: 'New Appointment',
          icon: Icons.book_outlined,
          onPressed: () => showAppointmentSideSheet(context),
          width: 275,
        )
      ],
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(50),
            const Expanded(child: AppoinmentsBody()),
          ],
        ),
      ),
    );
  }
}
