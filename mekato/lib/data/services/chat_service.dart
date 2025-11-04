import 'package:mekato/data/controllers/chat_controller.dart';
import 'package:mekato/data/services/auth_service.dart';

class ChatService {
  static final ChatService _instance = ChatService._();
  ChatService._();
  factory ChatService() => _instance;

  final ChatController _controller = ChatController();

  /// Envía un mensaje al backend. Obtiene el token desde AuthService automáticamente.
  Future<Map<String, dynamic>> sendMessage(String baseUrl, String message) async {
    final token = AuthService().authToken;
    return await _controller.sendMessage(baseUrl, message, token: token);
  }
}
