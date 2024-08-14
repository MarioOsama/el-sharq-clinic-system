import 'package:el_sharq_clinic/features/appointments/logic/cubit/case_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaseHistoryBlocListener extends StatelessWidget {
  const CaseHistoryBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CaseHistoryCubit, CaseHistoryState>(
      listenWhen: (previous, current) =>
          current is CaseHistoryLoading ||
          current is CaseHistoryError ||
          current is CaseHistorySuccess ||
          current is NewAppointmentLoading ||
          current is NewAppointmentFailure ||
          current is NewCaseHistoryuccess ||
          current is NewAppointmentInvalid,
      listener: (context, state) {
        state.showMessage(context);
      },
      child: const SizedBox.shrink(),
    );
  }
}
