import 'package:flutter/material.dart';
import 'package:mekato/data/controllers/account_controller.dart';
import 'package:mekato/data/models/user.dart';
import 'package:mekato/data/services/auth_service.dart';
import 'package:mekato/ui/widgets/account_widgets.dart';
import 'package:mekato/ui/core/mekato_colors.dart';
import 'edit_profile_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AccountController _controller = AccountController();
  User? _account;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAccount();
  }

  Future<void> _loadAccount() async {
    final token = AuthService().authToken;
    final account = await _controller.fetchAccount(token);
    setState(() {
      _account = account;
      _loading = false;
    });
  }

  Future<void> _openEdit() async {
    if (_account == null) return;

    final result = await Navigator.push<User>(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen(account: _account!)),
    );

    if (result != null) {
      setState(() => _account = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_account == null) {
      return const Scaffold(
        body: Center(child: Text('Error al cargar los datos del usuario')),
      );
    }

    return Scaffold(
      backgroundColor: MekatoColors.accent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: AccountAvatar(imagePath: "", size: 170),
            ),
            const SizedBox(height: 20),
            const LabeledTitle(title: 'Nombre:'),
            Text(
              "${_account!.nombres} ${_account!.apellidos}",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            const LabeledTitle(title: 'Teléfono:'),
            Text(
              _account!.telefono,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),
            const LabeledTitle(title: 'E-mail:'),
            Text(
              _account!.email,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MekatoColors.main,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  'Modificar perfil',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _openEdit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
