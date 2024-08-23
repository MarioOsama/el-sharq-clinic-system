import 'package:el_sharq_clinic/features/services/logic/cubit/services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicesBlocListener extends StatelessWidget {
  const ServicesBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServicesCubit, ServicesState>(
      listenWhen: (_, current) =>
          current is ServicesError ||
          current is ServiceSaving ||
          current is ServiceAdded ||
          current is ServiceDeleted ||
          current is ServiceUpdated ||
          current is ServiceError,
      listener: (context, state) {
        state.takeAction(context);
      },
      child: const SizedBox.shrink(),
    );
  }
}
