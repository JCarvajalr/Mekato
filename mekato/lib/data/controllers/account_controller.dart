import 'package:mekato/data/models/account_model.dart';
import 'package:mekato/data/services/account_service.dart';

class AccountController {
  final AccountService _service = AccountService();

  /// Obtiene el perfil del usuario autenticado usando su token.
  Future<AccountModel?> fetchAccount(String token) async {
    final data = await _service.getProfile(token);
    if (data == null) return null;

    return AccountModel(
      name: '${data["first_name"] ?? ''} ${data["last_name"] ?? ''}'.trim(),
      phone: data["phone"] ?? '',
      email: data["email"] ?? '',
      imagePath: data["image_url"], // opcional si tu backend devuelve URL
    );
  }

  /// Envía al backend las modificaciones del perfil.
  Future<bool> updateAccount(AccountModel account, String token) async {
    final parts = account.name.split(' ');
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    final Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName,
      'phone': account.phone,
      'email': account.email,
    };

    return await _service.updateProfile(body, token);
  }
}
