import 'package:app/models/lottery.dart';
import 'package:app/models/messages.dart';
import 'package:app/models/step.dart';
import 'package:app/providers/lottery_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Represents the state of the MyApp application.
/// This class extends [ChangeNotifier] to provide change notification to its listeners.
class MyAppState extends ChangeNotifier {
  final LotteryProvider lotteryProvider;

  final List<Message> messages = [];
  Lottery lottery = Lottery();
  var currentStep = 0;
  var errorCount = 0;
  var minSeries = 0;
  var maxSeries = 0;

  MyAppState({required this.lotteryProvider});

  void addMessage(Message message) {
    messages.add(message);
    steps[currentStep].action(this);
  }

  void _managementError() {
    errorCount++;
    if (errorCount == 3) {
      messages.add(Message.create(
          'Has cometido demasiados errores, por favor intenta de nuevo',
          false));
      notifyListeners();
      _reset();
      return;
    }
    messages.add(Message.create('Error, por favor intenta de nuevo', false));
    notifyListeners();
  }

  bool _isValidNumber(String input) {
    final number = int.tryParse(input);
    return number != null && number > 0;
  }

  void _nextStep() {
    String text = steps[currentStep].text;
    if (text.isNotEmpty) {
      messages.add(Message.create(text, false));
    }
    currentStep++;
    errorCount = 0;
    notifyListeners();
  }

  void _reset() {
    messages.clear();
    lotteryProvider.reset();
    currentStep = 0;
    errorCount = 0;
    notifyListeners();
  }

  void genericMessage() {
    messages.add(Message.create('Esto es un chat exclusivo de loteria', false));
    _nextStep();
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
      if (data.isEmpty) {
        messages
            .add(Message.create('La lotería $lastMessage no existe', false));
        _managementError();
        notifyListeners();
        return;
      }
      minSeries = data[0]['minSeries'];
      maxSeries = data[0]['maxSeries'];
      print(minSeries);
      print(maxSeries);
      lottery.setName(lastMessage);
      messages.add(Message.create('Lotería encontrada: $lastMessage', false));
      _nextStep();
    } catch (error) {
      print(error);
    }
  }

  void validateLottery() {
    String lastMessage = messages.last.text;
    if (!_isValidNumber(lastMessage) || lastMessage.length != 4) {
      messages.add(Message.create('Numero no valido vuelve a intentar', false));
      notifyListeners();
      _managementError();
      return;
    }
    lottery.setNumber(lastMessage);
    _nextStep();
  }

  void validateSeries() {
    String lastMessage = messages.last.text;
    if (!_isValidNumber(lastMessage) ||
        int.parse(lastMessage) < minSeries ||
        int.parse(lastMessage) > maxSeries) {
      messages.add(Message.create('Serie no valida, vuelve a intentar', false));
      notifyListeners();
      _managementError();
      return;
    }
    lottery.setSeries(lastMessage);
    messages.add(Message.create(
        'Has solicitado jugar con los números: ${lottery.number} en la serie: ${lottery.series}.',
        false));
    lotteryProvider.addLottery(lottery);
    lottery = Lottery();
    _nextStep();
  }

  void canBuyMoreTickets() {
    String lastMessage = messages.last.text;
    if (lastMessage.toLowerCase() == 'si') {
      currentStep = 0;
      _nextStep();
      return;
    }
    if (lastMessage.toLowerCase() == 'no') {
      _nextStep();
      steps[currentStep].action(this);
      return;
    }
    messages
        .add(Message.create('Respuesta no valida, vuelve a intentar', false));
    notifyListeners();
    _managementError();
  }

  void rememberBuy() {
    String message = lotteryProvider.messageOfAllLoteries();
    print(message);
    messages.add(Message.create(message, false));
    _nextStep();
    notifyListeners();
  }

  void confirmBuy() {
    String lastMessage = messages.last.text;
    if (lastMessage.toLowerCase() == 'si') {
      messages.add(Message.create('Compra confirmada', false));
      _nextStep();
      currentStep = 0;
      return;
    }
    if (lastMessage.toLowerCase() == 'no') {
      messages.add(Message.create('Compra cancelada', false));
      _reset();
      return;
    }
  }

  final List<Stepp> steps = [
    Stepp(
        text: "¿Qué lotería deseas comprar?",
        action: (state) => state.genericMessage()),
    Stepp(
        text: "¿Cuáles números quieres jugar?",
        action: (state) => state.fetchLotteryData()),
    Stepp(
        text: "¿Cuál serie deseas jugar?",
        action: (state) => state.validateLottery()),
    Stepp(
        text: "¿Deseas agregar otro boleto? (sí/no)",
        action: (state) => state.validateSeries()),
    Stepp(text: "", action: (state) => state.canBuyMoreTickets()),
    Stepp(
        text: "¿Deseas confirmar la compra? (si/no)",
        action: (state) => state.rememberBuy()),
    Stepp(text: "Buena Suerte", action: (state) => state.confirmBuy()),
  ];
}
