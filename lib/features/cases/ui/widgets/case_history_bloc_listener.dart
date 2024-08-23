import 'package:el_sharq_clinic/features/cases/logic/cubit/case_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaseHistoryBlocListener extends StatelessWidget {
  const CaseHistoryBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CaseHistoryCubit, CaseHistoryState>(
      listenWhen: (previous, current) =>
          current is CasesError ||
          current is CasesSuccess ||
          current is NewCaseHistoryLoading ||
          current is NewCaseHistoryFailure ||
          current is NewCaseHistorySuccess ||
          current is NewCaseHistoryInvalid ||
          current is UpdateCaseHistorySuccess ||
          current is DeleteCaseHistorySuccess,
      listener: (context, state) {
        state.takeAction(context);
      },
      child: const SizedBox.shrink(),
    );
  }
}
