import 'package:flutter/material.dart';
import 'package:mekato/ui/core/mekato_colors.dart';

class MekatoNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MekatoNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: MekatoColors.main,
      onTap: onTap,
      selectedItemColor: Colors.white,
      unselectedItemColor: const Color.fromARGB(255, 243, 226, 172),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      selectedIconTheme: IconThemeData(
        size: 30,
        shadows: [
          Shadow(
            color: const Color.fromARGB(255, 246, 247, 198).withOpacity(0.5),
            blurRadius: 16,
            offset: Offset(0, 0),
          ),
        ],
      ),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.stars_rounded),
          label: 'Reservas',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cuenta'),
      ],
    );
  }
}
