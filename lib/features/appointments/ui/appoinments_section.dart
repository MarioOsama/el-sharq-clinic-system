import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/features/appointments/logic/cubit/appointments_cubit.dart';
import 'package:el_sharq_clinic/features/appointments/ui/widgets/appoinments_body.dart';
import 'package:el_sharq_clinic/features/appointments/ui/widgets/appointment_side_sheet.dart';
import 'package:el_sharq_clinic/features/appointments/ui/widgets/appointments_bloc_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppoinmentsSection extends StatelessWidget {
  const AppoinmentsSection({super.key, required this.authData});

  final AuthDataModel authData;

  @override
  Widget build(BuildContext context) {
    context.read<AppointmentsCubit>().setAuthData(authData);
    return SectionContainer(
      title: 'Appoinments',
      actions: [
        AppTextButton(
          text: 'New Appointment',
          icon: Icons.book_outlined,
          onPressed: () =>
              showAppointmentSideSheet(context, 'New Appointment', isNew: true),
          width: 275,
        )
      ],
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(50),
            const Expanded(child: AppoinmentsBody()),
            const AppointmentsBlocListener(),
          ],
        ),
      ),
    );
  }
}
