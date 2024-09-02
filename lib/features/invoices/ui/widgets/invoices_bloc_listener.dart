import 'package:el_sharq_clinic/features/invoices/logic/cubit/invoices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoicesBlocListener extends StatelessWidget {
  const InvoicesBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<InvoicesCubit, InvoicesState>(
      listenWhen: (previous, current) =>
          current is InvoiceConstrutingError ||
          current is InvoiceSuccessOperation ||
          current is InvoiceInProgress,
      listener: (context, state) {
        state.takeAction(context);
      },
      child: const SizedBox.shrink(),
    );
  }
}
