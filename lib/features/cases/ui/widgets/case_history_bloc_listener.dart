import 'package:el_sharq_clinic/features/cases/logic/cubit/cases_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaseHistoryBlocListener extends StatelessWidget {
  const CaseHistoryBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CasesCubit, CasesState>(
      listenWhen: (previous, current) =>
          current is CasesError ||
          current is CasesSuccess ||
          current is NewCaseLoading ||
          current is NewCaseFailure ||
          current is NewCaseSuccess ||
          current is NewCaseHistoryInvalid ||
          current is UpdateCaseSuccess ||
          current is DeleteCaseSuccess,
      listener: (context, state) {
        state.takeAction(context);
      },
      child: const SizedBox.shrink(),
    );
  }
}
