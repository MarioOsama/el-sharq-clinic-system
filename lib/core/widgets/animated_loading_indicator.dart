import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class AnimatedLoadingIndicator extends StatefulWidget {
  const AnimatedLoadingIndicator({super.key});

  @override
  State<AnimatedLoadingIndicator> createState() =>
      _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<AnimatedLoadingIndicator>
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
        child: const Icon(
          Icons.pets,
          size: 60,
          color: AppColors.blue,
        ));
  }
}
