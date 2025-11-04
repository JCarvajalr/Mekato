import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mekato/ui/core/mekato_colors.dart';

class AccountAvatar extends StatelessWidget {
  final String? imagePath;
  final double size;
  const AccountAvatar({super.key, this.imagePath, this.size = 160});

  @override
  Widget build(BuildContext context) {
    final bg = MekatoColors.accent;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Center(
        child: imagePath == null || imagePath!.isEmpty
            ? Icon(
                Icons.person_outline,
                size: size * 0.45,
                color: MekatoColors.main,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(size * 0.25),
                child: Image.file(
                  File(imagePath!),
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}

class LabeledTitle extends StatelessWidget {
  final String title;
  const LabeledTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
      child: Text(
        title,
        style: TextStyle(
          color: MekatoColors.main,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: MekatoColors.main,
          decorationThickness: 2,
        ),
      ),
    );
  }
}
