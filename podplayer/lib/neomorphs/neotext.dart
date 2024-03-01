import 'package:flutter/material.dart';

class NeumorphicText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const NeumorphicText({super.key, required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(
        shadows: [
          Shadow(
            offset: const Offset(5.0, 5.0),
            blurRadius: 10.0,
            color: Colors.grey.shade300,
          ),
          Shadow(
            offset: const Offset(-5.0, -5.0),
            blurRadius: 10.0,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}
