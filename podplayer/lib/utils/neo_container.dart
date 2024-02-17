import 'package:flutter/material.dart';
import 'package:podplayer/constants/app_colors.dart';

class NeormphContainer extends StatelessWidget {
  const NeormphContainer(
      {Key? key,
      required this.size,
      required this.child,
      this.onPressed,
      this.blur = 20,
      this.distance = 10,
      this.color,
      this.imageUrl})
      : super(key: key);
  final double size;
  final Widget child;
  final VoidCallback? onPressed;
  final double blur;
  final double distance;
  final List<Color>? color;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: color == null ? AppColors.bgColor : color![1],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: AppColors.white,
              blurRadius: blur,
              offset: Offset(-distance, -distance)),
          BoxShadow(
              color: AppColors.bgDark,
              blurRadius: blur,
              offset: Offset(distance, distance))
        ],
      ),
      width: size,
      height: size,
      child: imageUrl != null
          ? CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(imageUrl!),
            )
          : Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.bgColor,
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: color ??
                          [
                            AppColors.white,
                            AppColors.bgDark,
                          ])),
              child: child,
            ),
    );
  }
}
