import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mekato/data/models/chat_message.dart';
import 'package:mekato/data/services/chat_service.dart';

class ChatManager {
  static final ChatManager _instance = ChatManager._();
  ChatManager._();
  factory ChatManager() => _instance;

  // Public notifiers UI can listen to
  final ValueNotifier<List<ChatMessage>> messages = ValueNotifier<List<ChatMessage>>([]);
  final ValueNotifier<bool> loading = ValueNotifier<bool>(false);

  // Send a message: manager will add the user message, call the service and append the bot reply(s).
  Future<void> send(String baseUrl, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    // Add user message immediately
    final current = List<ChatMessage>.from(messages.value);
    current.add(ChatMessage(text: trimmed, isUser: true));
    messages.value = current;

    loading.value = true;

    try {
      final data = await ChatService().sendMessage(baseUrl, trimmed);

      // Handle non-200 returned as {'statusCode': n}
      if (data.containsKey('statusCode') && data['statusCode'] != 200) {
        final status = data['statusCode'];
        if (status == 401) {
          _appendBotMessage('No autorizado. Proporcione un token válido en la configuración del chat.');
        } else {
          _appendBotMessage('Error del servidor: $status');
        }
      } else if (data.isEmpty) {
        _appendBotMessage('Error al conectar con el servidor');
      } else {
        final apiMessage = data['message'] ?? data['data']?['reply'] ?? 'Sin respuesta';

        // If there are reservas in the response, format them
        if (data['data'] != null && data['data']['reservas'] != null) {
          final reservas = data['data']['reservas'] as List<dynamic>;
          final buffer = StringBuffer();
          buffer.writeln(apiMessage);
          for (var r in reservas) {
            try {
              final fecha = r['fecha_reserva'] ?? r['fecha'] ?? '';
              final hora = r['hora_reserva'] ?? '';
              final estado = r['estado_reserva'] ?? '';
              buffer.writeln('- $fecha ${hora ?? ''} ($estado)');
            } catch (_) {}
          }
          _appendBotMessage(buffer.toString().trim());
        } else {
          _appendBotMessage(apiMessage.toString());
        }
      }
    } catch (e) {
      _appendBotMessage('Error al conectar con el servidor: ${e.toString()}');
    } finally {
      loading.value = false;
    }
  }

  void _appendBotMessage(String text) {
    final current = List<ChatMessage>.from(messages.value);
    current.add(ChatMessage(text: text, isUser: false));
    messages.value = current;
  }

  // Optional: helper to clear messages
  void clear() {
    messages.value = [];
  }
}
