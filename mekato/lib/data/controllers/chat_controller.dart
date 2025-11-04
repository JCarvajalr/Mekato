import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatController {
  // Envía un mensaje al endpoint del chatbot.
  // baseUrl: ejemplo 'http://10.0.2.2:8000' o 'http://127.0.0.1:8000'
  Future<Map<String, dynamic>> sendMessage(String baseUrl, String message, {String token = ''}) async {
    try {
      final uri = Uri.parse('$baseUrl/api/chatbot/');
      final headers = {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final body = json.encode({'message': message});
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        return {'statusCode': response.statusCode};
      }
    } catch (e) {
      debugPrint('ChatController.sendMessage error: $e');
      return {};
    }
  }
}
