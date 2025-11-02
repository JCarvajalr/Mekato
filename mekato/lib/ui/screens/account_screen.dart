import 'package:flutter/material.dart';
import 'package:mekato/ui/widgets/account_model.dart';
import 'package:mekato/ui/widgets/account_widgets.dart';
import 'package:mekato/ui/core/mekato_colors.dart';
import 'edit_profile_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AccountModel account = AccountModel(
    name: 'John Doe',
    phone: '+186546846846',
    email: 'johndoe@example.com',
    imagePath: null,
  );

  Future<void> _openEdit() async {
    // Abrimos la pantalla de edición y esperamos el resultado.
    final result = await Navigator.push<AccountModel>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(account: account),
      ),
    );

    // Si hubo resultado, actualizamos el estado local
    if (result != null) {
      setState(() {
        account = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MekatoColors.accent,
      appBar: AppBar(
        backgroundColor: MekatoColors.main,
        title: const Text('Cuenta'),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: AccountAvatar(imagePath: account.imagePath, size: 170)),
            const SizedBox(height: 20),
            const LabeledTitle(title: 'Nombre:'),
            Text(
              account.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            const LabeledTitle(title: 'Telefono:'),
            Text(
              account.phone,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),
            const LabeledTitle(title: 'E-mail:'),
            Text(
              account.email ?? 'No proporcionado',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MekatoColors.main,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text('Modificar perfil', style: TextStyle(color: Colors.white)),
                onPressed: _openEdit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
