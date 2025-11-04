import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  // backendBaseUrl example: http://10.0.2.2:8000 or http://127.0.0.1:8000
  final String backendBaseUrl;
  // Optional JWT token; if not provided the user can paste one
  final String? token;

  const ChatScreen({super.key, required this.backendBaseUrl, this.token});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  String? _token;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _token = widget.token;
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text.trim(), isUser: true));
      _loading = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      final url = Uri.parse('${widget.backendBaseUrl}/api/chatbot/');
      final headers = {'Content-Type': 'application/json'};
      if (_token != null && _token!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $_token';
      }

      final body = jsonEncode({'message': text.trim()});
      final resp = await http.post(url, headers: headers, body: body).timeout(const Duration(seconds: 15));

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
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
          _messages.add(ChatMessage(text: buffer.toString().trim(), isUser: false));
        } else {
          _messages.add(ChatMessage(text: apiMessage.toString(), isUser: false));
        }
      } else if (resp.statusCode == 401) {
        _messages.add(const ChatMessage(text: 'No autorizado. Proporcione un token válido en la configuración del chat.', isUser: false));
      } else {
        _messages.add(ChatMessage(text: 'Error del servidor: ${resp.statusCode}', isUser: false));
      }
    } catch (e) {
      _messages.add(ChatMessage(text: 'Error al conectar con el servidor: ${e.toString()}', isUser: false));
    }

    setState(() {
      _loading = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showTokenDialog() {
    final ctl = TextEditingController(text: _token ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Token JWT (opcional)'),
        content: TextField(
          controller: ctl,
          decoration: const InputDecoration(hintText: 'Pega aquí tu token JWT'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              setState(() {
                _token = ctl.text.trim();
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat con Mekato'),
        actions: [
          IconButton(
            icon: const Icon(Icons.vpn_key),
            tooltip: 'Configurar token JWT',
            onPressed: _showTokenDialog,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  alignment: m.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: m.isUser ? Colors.blueAccent : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      m.text,
                      style: TextStyle(color: m.isUser ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (v) => _sendMessage(v),
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 26,
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                      onPressed: () => _sendMessage(_controller.text),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
