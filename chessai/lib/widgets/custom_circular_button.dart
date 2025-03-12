import 'package:flutter/material.dart';

class CustomCircularButton extends StatelessWidget {
  final IconData? icon;
  final Widget? customIcon;
  final Color color;
  final VoidCallback onPressed;
  final String label;

  const CustomCircularButton({
    super.key,
    this.icon,
    this.customIcon,
    required this.color,
    required this.onPressed,
    required this.label,
  }) : assert(icon != null || customIcon != null, 'Either icon or customIcon must be provided');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Colors.white, color.withOpacity(0.8), color],
              stops: const [0.2, 0.5, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.6),
                spreadRadius: 3,
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                spreadRadius: -2,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              splashColor: color.withOpacity(0.3),
              highlightColor: Colors.transparent,
              child: Center(
                child: customIcon ?? Icon(
                  icon,
                  size: 45,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                color: color.withOpacity(0.5),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}