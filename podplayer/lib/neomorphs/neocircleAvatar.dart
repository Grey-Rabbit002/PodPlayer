import 'package:flutter/material.dart';

class NeumorphicCircleAvatar extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isPlaying;

  const NeumorphicCircleAvatar(
      {super.key, required this.onPressed, required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(8.0, 8.0),
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade300,
          boxShadow: [
            const BoxShadow(
              offset: Offset(-5.0, -5.0),
              blurRadius: 10.0,
              color: Colors.white,
            ),
            BoxShadow(
              offset: const Offset(5.0, 5.0),
              blurRadius: 10.0,
              color: Colors.grey.shade500,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 55,
          backgroundColor: Colors.transparent,
          child: IconButton(
            iconSize: 50,
            onPressed: onPressed,
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}
