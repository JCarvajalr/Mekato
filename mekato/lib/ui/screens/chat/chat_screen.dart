import 'package:flutter/material.dart';
import 'package:mekato/data/services/chat_manager.dart';
import 'package:mekato/data/models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  // backendBaseUrl example: http://10.0.2.2:8000 or http://127.0.0.1:8000
  final String backendBaseUrl;
  const ChatScreen({super.key, required this.backendBaseUrl});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  // UI should not contain logic; delegate to ChatManager
  Future<void> _onSend() async {
    final text = _controller.text;
    if (text.trim().isEmpty) return;

    // Clear input (UI concern)
    _controller.clear();

    // Delegate send logic to ChatManager
    await ChatManager().send(widget.backendBaseUrl, text.trim());

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

  // Token input UI removed: token comes solely from AuthService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat con Mekato'),
        // Token is managed centrally by AuthService; no user input allowed here.
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<List<ChatMessage>>(
              valueListenable: ChatManager().messages,
              builder: (context, messages, _) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final m = messages[index];
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
                );
              },
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: ChatManager().loading,
            builder: (context, loading, _) {
              return loading ? const LinearProgressIndicator() : const SizedBox.shrink();
            },
          ),
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
                      onSubmitted: (v) => _onSend(),
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                      onPressed: () => _onSend(),
                    ),
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
