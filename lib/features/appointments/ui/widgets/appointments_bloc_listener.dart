import 'package:el_sharq_clinic/features/appointments/logic/cubit/appointments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsBlocListener extends StatelessWidget {
  const AppointmentsBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentsCubit, AppointmentsState>(
      listenWhen: (previous, current) =>
          current is AppointmentsLoading ||
          current is AppointmentsError ||
          current is AppointmentsSuccess ||
          current is NewAppointmentLoading ||
          current is NewAppointmentFailure ||
          current is NewAppointmentSuccess ||
          current is NewAppointmentInvalid,
      listener: (context, state) {
        state.showMessage(context);
      },
      child: const SizedBox.shrink(),
    );
  }
}
