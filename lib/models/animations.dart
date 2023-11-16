import 'package:flutter/material.dart';

class AnimatedEllipsisProvider with ChangeNotifier {
  late AnimationController _controller;

  AnimatedEllipsisProvider(TickerProvider vsync) {
    _controller = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: vsync,
    )..repeat();
  }

  AnimationController get controller => _controller;

  @override
  void dispose() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
    super.dispose();
  }
}
