import 'package:flutter/material.dart';
import 'package:mekato/ui/core/mekato_colors.dart';

// ignore: must_be_immutable
class GradientButton extends StatelessWidget {
  final IconData iconB;
  final String labelB;
  final Function onTap;
  Color leftColor;
  Color rightColor;
  GradientButton({
    super.key,
    required this.iconB,
    required this.labelB,
    required this.onTap,
    this.leftColor = const Color(0xFFE89B0D),
    this.rightColor = MekatoColors.main,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [leftColor, rightColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton.icon(
        onPressed: () {
          onTap;
        },
        icon: Icon(iconB, size: 22),
        label: Text(
          labelB,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
