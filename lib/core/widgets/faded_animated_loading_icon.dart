import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class FadedAnimatedLoadingIcon extends StatefulWidget {
  const FadedAnimatedLoadingIcon(
      {super.key, this.iconData, this.size, this.color});

  final IconData? iconData;
  final double? size;
  final Color? color;

  @override
  State<FadedAnimatedLoadingIcon> createState() =>
      _FadedAnimatedLoadingIconState();
}

class _FadedAnimatedLoadingIconState extends State<FadedAnimatedLoadingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: _controller,
        child: Icon(
          widget.iconData ?? Icons.pets,
          size: widget.size ?? 60,
          color: widget.color ?? AppColors.blue,
        ));
  }
}
