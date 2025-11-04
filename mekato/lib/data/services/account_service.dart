import 'dart:convert';
import 'package:http/http.dart' as http;

class AccountService {
  static const String baseUrl = 'http://10.0.2.2:8000'; // localhost para emulador Android

  /// Obtiene el perfil actual del usuario.
  Future<Map<String, dynamic>?> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('❌ Error al obtener perfil: ${response.statusCode}');
        print(response.body);
        return null;
      }
    } catch (e) {
      print('⚠️ Error de conexión al obtener perfil: $e');
      return null;
    }
  }

  /// Actualiza los datos del perfil en el backend.
  Future<bool> updateProfile(Map<String, dynamic> data, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('❌ Error al actualizar perfil: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('⚠️ Error de conexión al actualizar perfil: $e');
      return false;
    }
  }
}
