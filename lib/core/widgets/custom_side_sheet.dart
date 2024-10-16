import 'package:flutter/material.dart';
import 'package:side_sheet/side_sheet.dart';

Future<void> showCustomSideSheet(
    {required BuildContext context,
    required Widget child,
    bool scrollable = true}) async {
  await SideSheet.right(
    context: context,
    width: MediaQuery.of(context).size.width * 0.45,
    body: scrollable
        ? _buildScrollableSheet(child)
        : _buildNonScrollableSheet(child),
  );
}

SingleChildScrollView _buildScrollableSheet(Widget child) {
  return SingleChildScrollView(
    child: _buildNonScrollableSheet(child),
  );
}

Padding _buildNonScrollableSheet(Widget child) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 35),
    child: child,
  );
}
