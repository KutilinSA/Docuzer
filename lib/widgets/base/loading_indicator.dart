import 'dart:math';

import 'package:docuzer/ui/custom_icons.dart';
import 'package:docuzer/widgets/base/block_card.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  final Color? color;
  final bool fullScreen;
  final double scale;

  const LoadingIndicator({this.color, this.fullScreen = false, this.scale = 1, Key? key}) : super(key: key);

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.fullScreen ? 1.5 : widget.scale;

    final row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Flashing(interval: const Interval(0.1, 0.7), controller: _controller, color: widget.color, scale: scale),
        SizedBox(width: scale * 8),
        _Flashing(
          interval: const Interval(0.2, 0.8),
          controller: _controller,
          child: Icon(CustomIcons.lock, size: scale * 24, color: widget.color ?? Colors.white),
        ),
        SizedBox(width: scale * 8),
        _Flashing(interval: const Interval(0.3, 0.9), controller: _controller, color: widget.color, scale: scale),
        SizedBox(width: scale * 8),
        _Flashing(interval: const Interval(0.4, 1), controller: _controller, color: widget.color, scale: scale),
      ],
    );

    if (widget.fullScreen) {
      return BlockCard(
        width: 200,
        child: row,
        padding: const EdgeInsets.symmetric(vertical: 24),
      );
    }
    return row;
  }
}

class _Flashing extends StatelessWidget {
  final Interval interval;
  final AnimationController controller;
  final Widget? child;
  final Color? color;
  final double scale;

  const _Flashing({ required this.interval, required this.controller, this.child, this.color, this.scale = 1 });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) {
        final flashPercent = sin(pi * interval.transform(controller.value));
        return Opacity(
          opacity: flashPercent,
          child: child ?? Container(
            width: scale * 8,
            height: scale * 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color ?? Colors.white,
            ),
          ),
        );
      },
    );
  }
}
