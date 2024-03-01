import 'package:flutter/material.dart';

class NeumorphicImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double borderRadius;

  const NeumorphicImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(8.0, 8.0),
            blurRadius: 10.0,
            spreadRadius: 5.0,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-5.0, -5.0),
            blurRadius: 10.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          filterQuality: FilterQuality.high,
          color: Colors.grey.shade400,
          colorBlendMode: BlendMode.colorBurn,
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}