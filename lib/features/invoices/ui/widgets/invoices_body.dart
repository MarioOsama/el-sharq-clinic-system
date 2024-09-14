import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/widgets/faded_animated_loading_icon.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table_data_source.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/invoices/logic/cubit/invoices_cubit.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoices_row_action_button.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoices_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoicesBody extends StatefulWidget {
  const InvoicesBody({super.key});

  @override
  State<InvoicesBody> createState() => _InvoicesBodyState();
}

class _InvoicesBodyState extends State<InvoicesBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicesCubit, InvoicesState>(
      buildWhen: (previous, current) =>
          current is InvoicesSuccess ||
          current is InvoicesError ||
          current is InvoicesLoading,
      builder: (context, state) {
        return SectionDetailsContainer(
          color: state is InvoicesSuccess
              ? AppColors.darkGrey.withOpacity(0.75)
              : AppColors.white,
          child: _buildChild(state),
        );
      },
    );
  }

  Widget _buildChild(InvoicesState state) {
    if (state is InvoicesSuccess) {
      return _buildSuccess(state);
    } else if (state is InvoicesError) {
      return Center(
        child: Text(state.message),
      );
    }
    return const Center(child: FadedAnimatedLoadingIcon());
  }

  CustomTable _buildSuccess(InvoicesState state) {
    final invoicesCubit = context.read<InvoicesCubit>();
    return CustomTable(
      onPageChanged: (firstIndex) => invoicesCubit.getNextPage(firstIndex),
      fields: AppConstant.invoicesTableHeaders,
      dataSource: CustomTableDataSource(
        columnsCount: AppConstant.invoicesTableHeaders.length,
        data: _getRows(state),
        actionBuilder: (id) => InvoicesRowActionButton(
          id: id,
        ),
        tappableCellIndex: 0,
        onSelectionChanged: (index, selected) => setState(() {
          invoicesCubit.onMultiSelection(index, selected);
        }),
        onTappableCellTap: (id) => showInvoiceSheet(
            context, AppStrings.invoiceDetails.tr(),
            invoice: invoicesCubit.getInvoiceById(id), editable: false),
        selectedRows: invoicesCubit.selectedRows,
      ),
    );
  }

  List<List<String>> _getRows(InvoicesState state) {
    return (state as InvoicesSuccess).invoices.map((ivnoice) {
      return ivnoice!.toList();
    }).toList();
  }
}
