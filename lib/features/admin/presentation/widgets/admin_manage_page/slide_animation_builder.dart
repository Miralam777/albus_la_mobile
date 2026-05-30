import 'package:flutter/material.dart';

class SlideAnimationBuilder extends StatefulWidget {
  const SlideAnimationBuilder({super.key, required this.child});

  final Widget child;

  @override
  State<SlideAnimationBuilder> createState() => _SlideAnimationBuilderState();
}

class _SlideAnimationBuilderState extends State<SlideAnimationBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: -250.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: _animation.value,
          left: 0,
          right: 0,
          child: widget.child,
        );
      },
    );
  }
}
