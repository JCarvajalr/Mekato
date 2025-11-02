import 'package:flutter/material.dart';
import 'package:mekato/ui/core/mekato_colors.dart';
import 'package:mekato/ui/screens/dashboard.dart';
import 'package:mekato/ui/widgets/mekato_navbar.dart';
import 'package:mekato/ui/screens/account_screen.dart'; 

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onNavbarTap(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Dashboard(),
      // Si tienes pantalla de reservas, ponla aquí
      Container(child: Center(child: Text('Reservas (placeholder)'))),
      const AccountScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MekatoColors.main,
        foregroundColor: Colors.white,
        title: Text("Mekato"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: MekatoNavbar(
        currentIndex: _selectedIndex,
        onTap: _onNavbarTap,
      ),
    );
  }
}
