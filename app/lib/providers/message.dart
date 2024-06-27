import 'package:app/models/Messages.dart';
import 'package:app/models/Step.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAppState extends ChangeNotifier {
  final List<Message> messages = [];
  var currentStep = 0;
  var errorCount = 0;

  void managementError() {
    errorCount++;
    if (errorCount == 3) {
      messages.add(Message.create(
          'Has cometido demasiados errores, por favor intenta de nuevo',
          false));
      notifyListeners();
      messages.clear();
      return;
    }
    messages.add(Message.create('Error, por favor intenta de nuevo', false));
    notifyListeners();
  }

  void addMessage(Message message) {
    messages.add(message);
    steps[currentStep].action(this);
  }

  void nextStep() {
    String text = steps[currentStep].text;
    messages.add(Message.create(text, false));
    currentStep++;
    notifyListeners();
  }

  void fetchLotteryData() async {
    String lastMessage = messages.last.text;
    try {
      final url = Uri.parse(
          'http://192.168.0.22:8000/api/v1/lotteries?lotteryName=$lastMessage');
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to load lottery data');
      }
      // Successful response
      final Map<String, dynamic> baseData = json.decode(response.body);
      final List<dynamic> data = baseData['data'];
      print(data);
      if (data.isEmpty) {
        messages
            .add(Message.create('La lotería $lastMessage no existe', false));
        managementError();
        notifyListeners();
        return;
      }
      messages.add(Message.create('Lotería encontrada: $lastMessage', false));
      nextStep();
    } catch (error) {
      print(error);
    }
  }

  bool _isValidNumber(String input) {
    final number = int.tryParse(input);
    return number != null && number > 0;
  }

  void validateLottery() {
    String lastMessage = messages.last.text;
    if (!_isValidNumber(lastMessage) || lastMessage.length != 4) {
      messages.add(Message.create('Numero no valido vuelve a intentar', false));
      notifyListeners();
      managementError();
      return;
    }
    nextStep();
  }

  final List<Stepp> steps = [
    Stepp(
        text:
            "Esto es un chat exclusivo de loteria, ¿Qué lotería deseas comprar?",
        action: (state) => state.nextStep()),
    Stepp(
        text: "¿Cuáles números quieres jugar?",
        action: (state) => state.fetchLotteryData()),
    Stepp(
        text: "¿Cuál serie deseas jugar?",
        action: (state) => state.validateLottery()),
    Stepp(
        text:
            "Has solicitado jugar con los números: _chosenNumbers en la serie: _chosenSeries. ¿Deseas agregar otro boleto? (sí/no)",
        action: (state) => state.fetchLotteryData()),
    Stepp(
        text:
            "Has solicitado los siguientes boletos:\nticketSummary\n¿Deseas confirmar la compra? (sí/no)",
        action: (state) => state.fetchLotteryData()),
    Stepp(
        text:
            "Compra confirmada con los siguientes boletos:\n{_tickets.map((ticket) => Loteria: {ticket['lottery']} Número: {ticket['numbers']}, Serie: {ticket['series']}).join('\n')}\n¡Buena suerte!",
        action: (state) => state.fetchLotteryData()),
    Stepp(
        text: "Compra cancelada.", action: (state) => state.fetchLotteryData()),
  ];
}
