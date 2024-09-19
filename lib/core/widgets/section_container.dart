import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  const SectionContainer(
      {super.key,
      required this.child,
      required this.title,
      this.actions,
      this.alignment,
      this.padding});

  final Widget child;
  final String title;
  final List<Widget>? actions;
  final Alignment? alignment;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.topLeft,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
      child: Column(
        crossAxisAlignment: alignment == Alignment.center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
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
