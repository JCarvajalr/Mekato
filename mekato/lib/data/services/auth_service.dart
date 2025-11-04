import 'package:mekato/data/controllers/auth_controller.dart';
import 'package:mekato/data/models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._();

  AuthService._();

  factory AuthService() {
    return _instance;
  }

  AuthController controller = AuthController();
  String authToken = "";

  Future<bool> login(String email, String password) async {
    final body = {'email': email, 'contraseña': password};

    final response = await controller.login(body);
    if (response.isNotEmpty) {
      final String token = response['data']['access_token'];
      authToken = token;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(User user) async {
    final body = user.toJson();

    final response = await controller.register(body);
    if (response.isNotEmpty) {
      login(user.email, user.password);
      // final String token = response['data']['access_token'];
      // authToken = token;
      return true;
    } else {
      return false;
    }
  }

  void logout() {
    authToken = "";
  }
}
