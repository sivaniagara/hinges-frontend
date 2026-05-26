import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final VoidCallback onDone;

  const ChatBubble({
    required this.message,
    required this.onDone,
  });

  @override
  State<ChatBubble> createState() => ChatBubbleState();
}

class ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _move;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacity = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _move = Tween(begin: 20.0, end: 10.0).animate(_controller);

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      widget.onDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _move.value),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          widget.message,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}