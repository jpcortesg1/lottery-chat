import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = []; // Store messages as maps
  final List<Map<String, String>> _tickets = []; // Store lottery tickets
  String? _lotteryData; // To store fetched lottery data
  int _currentStep = 0; // Variable to track the current step in the conversation
  int _errorCount = 0; // Variable to count errors
  String _lotteryName = ''; // To store the chosen lottery name
  String _chosenNumbers = ''; // To store the chosen numbers
  String _chosenSeries = ''; // To store the chosen series

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<String> _fetchLotteryData(String lotteryName) async {
    try {
      final url = Uri.parse(
          'http://192.168.1.5:8000/api/v1/lotteries?lotteryName=$lotteryName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Successful response
        final Map<String, dynamic> baseData = json.decode(response.body);
        print(baseData);
        final List<dynamic> data = baseData['data'];
        if (data.isNotEmpty) {
          return 'Lotería encontrada: $lotteryName';
        } else {
          return 'La lotería $lotteryName no existe';
        }
      } else {
        // Handle error
        throw Exception('Failed to load lottery data');
      }
    } catch (error) {
      print(error);
      return 'Error fetching lottery data';
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({'text': _messageController.text, 'isUserMessage': true});
        final userMessage = _messageController.text;
        _messageController.clear(); // Clear the text field after sending

        if (_currentStep == 0) {
          _messages.add({
            'text': "Esto es un chat exclusivo de loteria, ¿Qué lotería deseas comprar?",
            'isUserMessage': false
          });
          _currentStep++;
        } else if (_currentStep == 1) {
          _lotteryName = userMessage; // Store the chosen lottery name
          _fetchLotteryData(userMessage).then((response) {
            setState(() {
              _messages.add({'text': response, 'isUserMessage': false});
              if (response.startsWith('Lotería encontrada')) {
                _messages.add({
                  'text': "¿Cuáles números quieres jugar?",
                  'isUserMessage': false
                });
                _currentStep++;
              } else {
                _handleError();
              }
              _scrollToBottom();
            });
          });
        } else if (_currentStep == 2) {
          if (_isValidNumber(userMessage)) {
            _chosenNumbers = userMessage; // Store the chosen numbers
            _messages.add({
              'text': "¿Cuál serie deseas jugar?",
              'isUserMessage': false
            });
            _currentStep++;
          } else {
            _handleError();
          }
        } else if (_currentStep == 3) {
          if (_isValidNumber(userMessage)) {
            _chosenSeries = userMessage; // Store the chosen series
            _tickets.add({'numbers': _chosenNumbers, 'series': _chosenSeries});
            _messages.add({
              'text': "Has solicitado jugar con los números: $_chosenNumbers en la serie: $_chosenSeries. ¿Deseas agregar otro boleto? (sí/no)",
              'isUserMessage': false
            });
            _currentStep++;
          } else {
            _handleError();
          }
        } else if (_currentStep == 4) {
          if (userMessage.toLowerCase() == 'si' || userMessage.toLowerCase() == 'sí') {
            _messages.add({
              'text': "¿Qué lotería deseas jugar?",
              'isUserMessage': false
            });
            _currentStep = 2; // Go back to the step to choose a lottery
          } else if (userMessage.toLowerCase() == 'no') {
            String ticketSummary = _tickets.map((ticket) => "Números: ${ticket['numbers']}, Serie: ${ticket['series']}").join('\n');
            _messages.add({
              'text': "Has solicitado los siguientes boletos:\n$ticketSummary\n¿Deseas confirmar la compra? (sí/no)",
              'isUserMessage': false
            });
            _currentStep++;
          } else {
            _handleError();
          }
        } else if (_currentStep == 5) {
          if (userMessage.toLowerCase() == 'si' || userMessage.toLowerCase() == 'sí') {
            _messages.add({
              'text': "Compra confirmada para la lotería $_lotteryName con los siguientes boletos:\n${_tickets.map((ticket) => "Números: ${ticket['numbers']}, Serie: ${ticket['series']}").join('\n')}\n¡Buena suerte!",
              'isUserMessage': false
            });
          } else if (userMessage.toLowerCase() == 'no') {
            _messages.add({
              'text': "Compra cancelada.",
              'isUserMessage': false
            });
          } else {
            _handleError();
          }
          _currentStep = 0; // Reset the conversation flow after confirmation
          _tickets.clear(); // Clear the tickets list after confirmation or cancellation
          _errorCount = 0; // Reset the error count
        }
        _scrollToBottom();
      });
    }
  }

  bool _isValidNumber(String input) {
    final number = int.tryParse(input);
    return number != null && number > 0;
  }

  void _handleError() {
    _errorCount++;
    if (_errorCount >= 3) {
      _messages.add({
        'text': "Has cometido demasiados errores. Volvamos a empezar.",
        'isUserMessage': false
      });
      _currentStep = 0; // Reset the conversation flow to the beginning
      _errorCount = 0; // Reset the error count
    } else {
      _messages.add({
        'text': "No entiendo tu respuesta. Por favor, inténtalo de nuevo.",
        'isUserMessage': false
      });
      // Optionally, repeat the last question based on _currentStep
      if (_currentStep == 2) {
        _messages.add({
          'text': "¿Cuáles números quieres jugar?",
          'isUserMessage': false
        });
      } else if (_currentStep == 3) {
        _messages.add({
          'text': "¿Cuál serie deseas jugar?",
          'isUserMessage': false
        });
      } else if (_currentStep == 4) {
        _messages.add({
          'text': "Has solicitado jugar con los números: $_chosenNumbers en la serie: $_chosenSeries. ¿Deseas agregar otro boleto? (sí/no)",
          'isUserMessage': false
        });
      } else if (_currentStep == 5) {
        String ticketSummary = _tickets.map((ticket) => "Números: ${ticket['numbers']}, Serie: ${ticket['series']}").join('\n');
        _messages.add({
          'text': "Has solicitado los siguientes boletos:\n$ticketSummary\n¿Deseas confirmar la compra? (sí/no)",
          'isUserMessage': false
        });
      }
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          // Display lottery data (optional)
          if (_lotteryData != null) Text('Lottery Data: $_lotteryData'),

          // Display messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isUserMessage = message['isUserMessage'];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                        decoration: BoxDecoration(
                          color: isUserMessage ? Colors.blueAccent : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(color: isUserMessage ? Colors.white : Colors.black87),
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
                  onPressed: _sendMessage,
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