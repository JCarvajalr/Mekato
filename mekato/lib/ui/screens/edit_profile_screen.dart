import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mekato/data/controllers/account_controller.dart';
import 'package:mekato/data/models/user.dart';
import 'package:mekato/data/services/auth_service.dart';
import 'package:mekato/ui/widgets/account_widgets.dart';
import 'package:mekato/ui/core/mekato_colors.dart';

class EditProfileScreen extends StatefulWidget {
  final User account;
  const EditProfileScreen({super.key, required this.account});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  String? _pickedImagePath;
  final ImagePicker _picker = ImagePicker();
  final AccountController _accountController = AccountController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _pickedImagePath = "";

    final firstName = widget.account.nombres;
    final lastName = widget.account.apellidos;

    _firstNameController = TextEditingController(text: firstName);
    _lastNameController = TextEditingController(text: lastName);
    _phoneController = TextEditingController(text: widget.account.telefono);
    _emailController = TextEditingController(text: widget.account.email);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      setState(() {
        _pickedImagePath = file.path;
      });
    }
  }

  Future<void> _onSave() async {
    setState(() => _saving = true);

    final updatedAccount = widget.account.copyWith(
      name: _firstNameController.text,
      lastName: _lastNameController.text,
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
    );

    final token = AuthService().authToken;

    final success = await _accountController.updateAccount(
      updatedAccount,
      token,
    );

    setState(() => _saving = false);

    if (success) {
      Navigator.pop(context, updatedAccount);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado correctamente.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el perfil.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil'),
        backgroundColor: MekatoColors.main,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickFromGallery,
              child: AccountAvatar(imagePath: _pickedImagePath, size: 160),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _pickFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text('Seleccionar foto'),
            ),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            _saving
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MekatoColors.main,
                        ),
                        onPressed: _onSave,
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
