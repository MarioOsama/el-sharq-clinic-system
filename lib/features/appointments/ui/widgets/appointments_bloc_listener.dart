import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/features/appointments/logic/cubit/appointments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsBlocListener extends StatelessWidget {
  const AppointmentsBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentsCubit, AppointmentsState>(
      listener: (context, state) {
        if (state is AppointmentsError) {
          showDialog(
            context: context,
            builder: (_) => AppDialog(
              title: state.title ?? 'Error',
              content: state.errorMessage,
              dialogType: DialogType.error,
            ),
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
