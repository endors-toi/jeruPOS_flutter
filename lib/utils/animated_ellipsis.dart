import 'package:flutter/material.dart';

class AnimatedEllipsis extends StatefulWidget {
  final double? size;

  AnimatedEllipsis({double? size}) : this.size = size ?? 24;

  @override
  _AnimatedEllipsisState createState() => _AnimatedEllipsisState();
}

class _AnimatedEllipsisState extends State<AnimatedEllipsis>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        String ellipsis = '●' * ((_controller.value * 3).toInt() + 1);
        return Text(ellipsis, style: TextStyle(fontSize: widget.size));
      },
    );
  }
}
