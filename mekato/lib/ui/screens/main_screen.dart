import 'package:flutter/material.dart';
import 'package:mekato/data/services/auth_service.dart';
import 'package:mekato/data/services/reservations_service.dart';
import 'package:mekato/ui/core/mekato_colors.dart';
import 'package:mekato/ui/screens/dashboard.dart';
import 'package:mekato/ui/screens/login_screen.dart';
import 'package:mekato/ui/screens/reservations/reservations_screen.dart';
import 'package:mekato/ui/screens/chat/chat_screen.dart';
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

  void _logout() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres salir de tu cuenta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.black),
            ),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sí, Cerrar Sesión'),
          ),
        ],
      ),
    );

    if (result == true) {
      AuthService().logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.6),
        backgroundColor: MekatoColors.main,
        foregroundColor: Colors.white,
        title: Image.asset("assets/images/LogoWhite.png", height: 40),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  _selectedIndex = 2;
                  setState(() {});
                  break;
                case 'reservations':
                  _selectedIndex = 1;
                  setState(() {});
                  break;
                case 'logout':
                  _logout();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: const [
                    Icon(Icons.person_outline, size: 20, color: Colors.black),
                    SizedBox(width: 12),
                    Text('Mi Perfil'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'reservations',
                child: Row(
                  children: const [
                    Icon(
                      Icons.calendar_month_rounded,
                      size: 20,
                      color: Colors.black,
                    ),
                    SizedBox(width: 12),
                    Text('Mis Reservas'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.logout, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: MekatoNavbar(
        currentIndex: _selectedIndex,
        onTap: _onNavbarTap,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: FloatingActionButton(
          heroTag: 'chat_fab',
          onPressed: () {
            final backendBaseUrl = 'http://186.183.171.16:25565';
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ChatScreen(backendBaseUrl: backendBaseUrl),
              ),
            );
          },
          backgroundColor: MekatoColors.main,
          foregroundColor: Colors.white,
          child: const Icon(Icons.chat_bubble_outline),
        ),
      ),
    );
  }
}
