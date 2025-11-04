import 'package:flutter/material.dart';
import 'package:mekato/data/services/reservations_service.dart';
import 'package:mekato/ui/core/mekato_colors.dart';
import 'package:mekato/ui/screens/dashboard.dart';
import 'package:mekato/ui/screens/reservations/reservations_screen.dart';
import 'package:mekato/ui/widgets/mekato_navbar.dart';
import 'package:mekato/ui/screens/account_screen.dart'; 

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  ReservationsService reservationsService = ReservationsService();
  List<Widget> get pages => [
    Dashboard(),
    ReservationsScreen(service: reservationsService),
    AccountScreen(),
  ];

  void _onNavbarTap(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.6),
        backgroundColor: MekatoColors.main,
        foregroundColor: Colors.white,
        title: Image.asset(
          "assets/images/LogoWhite.png",
          height: 40,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: MekatoNavbar(
        currentIndex: _selectedIndex,
        onTap: _onNavbarTap,
      ),
    );
  }
}
