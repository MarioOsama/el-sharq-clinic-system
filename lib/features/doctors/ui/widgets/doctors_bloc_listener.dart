import 'package:el_sharq_clinic/features/doctors/logic/cubit/doctors_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorsBlocListener extends StatelessWidget {
  const DoctorsBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorsCubit, DoctorsState>(
      listenWhen: (previous, current) =>
          current is DoctorsError ||
          current is DoctorLoading ||
          current is DoctorSaved ||
          current is DoctorUpdated ||
          current is DoctorDeleted,
      listener: (context, state) {
        state.takeAction(context);
      },
      child: const SizedBox.shrink(),
    );
  }
}
