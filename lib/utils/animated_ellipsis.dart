import 'package:flutter/material.dart';
import 'package:jerupos/models/animations.dart';
import 'package:provider/provider.dart';

class AnimatedEllipsis extends StatefulWidget {
  @override
  _AnimatedEllipsisState createState() => _AnimatedEllipsisState();
}

class _AnimatedEllipsisState extends State<AnimatedEllipsis>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = Provider.of<AnimatedEllipsisProvider>(context, listen: false)
        .controller;
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          String ellipsis = '●' * ((_controller.value * 3).toInt() + 1);
          return Text('$ellipsis', style: TextStyle(fontSize: 20));
        },
      );
    }
    return Container();
  }
}
