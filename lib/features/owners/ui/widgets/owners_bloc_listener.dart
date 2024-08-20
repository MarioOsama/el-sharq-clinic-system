import 'package:el_sharq_clinic/features/owners/logic/cubit/owners_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnersBlocListener extends StatelessWidget {
  const OwnersBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OwnersCubit, OwnersState>(
      listenWhen: (previous, current) =>
          current is OwnerLoading ||
          current is OwnersError ||
          current is NewOwnerAdded ||
          current is OwnerUpdated,
      listener: (context, state) {
        state.takeAction(context);
      },
      child: const SizedBox.shrink(),
    );
  }
}
