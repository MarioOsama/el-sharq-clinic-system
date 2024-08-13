import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  const SectionContainer(
      {super.key, required this.child, required this.title, this.actions});

  final Widget child;
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpace(30),
          actions != null ? _buildHeaderWithActions() : _buildHeader(),
          child,
        ],
      ),
    );
  }

  Row _buildHeaderWithActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SectionTitle(title: title),
        ...actions!,
      ],
    );
  }

  SectionTitle _buildHeader() {
    return SectionTitle(title: title);
  }
}
