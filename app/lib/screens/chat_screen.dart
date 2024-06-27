import 'package:app/models/messages.dart';
import 'package:app/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<MyAppState>(context);

    void sendMessage() {
      appProvider.addMessage(Message.create(_messageController.text, true));
      _messageController.clear();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          // Display messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: appProvider.messages.length,
              itemBuilder: (context, index) {
                final message = appProvider.messages[index];
                bool isUserMessage = message.isOwn;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: isUserMessage
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (!isUserMessage)
                        CircleAvatar(
                          // Add user profile image or initials here
                          child: Text('A'), // Placeholder for receiver's avatar
                        ),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6),
                        decoration: BoxDecoration(
                          color: isUserMessage
                              ? Colors.blueAccent
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                              color: isUserMessage
                                  ? Colors.white
                                  : Colors.black87),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // User input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
