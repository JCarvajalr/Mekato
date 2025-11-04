import 'package:mekato/data/models/user.dart';
import 'package:mekato/data/services/account_service.dart';

class AccountController {
  final AccountService _service = AccountService();

  /// Obtiene el perfil del usuario autenticado usando su token.
  Future<User?> fetchAccount(String token) async {
    final data = await _service.getProfile(token);
    if (data == null) return null;
    final user = data["usuario"];

    return User(
      nombres: user['nombre'],
      apellidos: user['apellidos'],
      email: user['email'],
      telefono: user['telefono'],
    );
  }

  /// Envía al backend las modificaciones del perfil.
  Future<bool> updateAccount(User account, String token) async {
    final Map<String, dynamic> body = account.toJson();
    return await _service.updateProfile(body, token);
  }
}
