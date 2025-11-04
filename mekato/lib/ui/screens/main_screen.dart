import 'package:flutter/material.dart';
import 'package:mekato/ui/core/mekato_colors.dart';
import 'package:mekato/ui/screens/dashboard.dart';
import 'package:mekato/ui/screens/reservations/reservations_screen.dart';
import 'package:mekato/ui/screens/chat/chat_screen.dart';
import 'package:mekato/ui/widgets/mekato_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> pages = [Dashboard(), ReservationsScreen(), Dashboard()];

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
        title: Text("Mekato"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: MekatoNavbar(
        currentIndex: _selectedIndex,
        onTap: _onNavbarTap,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: FloatingActionButton(
          heroTag: 'chat_fab',
          onPressed: () {
            // Ajusta backendBaseUrl según tu entorno de desarrollo (emulador Android usa 10.0.2.2)
            final backendBaseUrl = 'http://186.183.171.16:25565';
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ChatScreen(backendBaseUrl: backendBaseUrl),
            ));
          },
          backgroundColor: MekatoColors.main,
          child: const Icon(Icons.chat_bubble_outline),
        ),
      ),
    );
  }
}
