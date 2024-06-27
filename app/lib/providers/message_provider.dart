import 'package:app/models/lottery.dart';
import 'package:app/models/messages.dart';
import 'package:app/models/step.dart';
import 'package:app/providers/lottery_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAppState extends ChangeNotifier {
  final LotteryProvider lotteryProvider;

  final List<Message> messages = [];
  final Lottery lottery = Lottery();
  var currentStep = 0;
  var errorCount = 0;
  var minSeries = 0;
  var maxSeries = 0;

  MyAppState({required this.lotteryProvider});

  void managementError() {
    errorCount++;
    if (errorCount == 3) {
      messages.add(Message.create(
          'Has cometido demasiados errores, por favor intenta de nuevo',
          false));
      notifyListeners();
      reset();
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
    if (text.isNotEmpty) {
      messages.add(Message.create(text, false));
    }
    currentStep++;
    errorCount = 0;
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
      if (data.isEmpty) {
        messages
            .add(Message.create('La lotería $lastMessage no existe', false));
        managementError();
        notifyListeners();
        return;
      }
      minSeries = data[0]['minSeries'];
      maxSeries = data[0]['maxSeries'];
      print(minSeries);
      print(maxSeries);
      lottery.setName(lastMessage);
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
    lottery.setNumber(lastMessage);
    nextStep();
  }

  void validateSeries() {
    String lastMessage = messages.last.text;
    if (!_isValidNumber(lastMessage) ||
        int.parse(lastMessage) < minSeries ||
        int.parse(lastMessage) > maxSeries) {
      messages.add(Message.create('Serie no valida, vuelve a intentar', false));
      notifyListeners();
      managementError();
      return;
    }
    lottery.setSeries(lastMessage);
    messages.add(Message.create(
        'Has solicitado jugar con los números: ${lottery.number} en la serie: ${lottery.series}.',
        false));
    lotteryProvider.addLottery(lottery);
    nextStep();
  }

  void canBuyMoreTickets() {
    String lastMessage = messages.last.text;
    if (lastMessage.toLowerCase() == 'si') {
      currentStep = 0;
      nextStep();
      return;
    }
    if (lastMessage.toLowerCase() == 'no') {
      nextStep();
      steps[currentStep].action(this);
      return;
    }
    messages
        .add(Message.create('Respuesta no valida, vuelve a intentar', false));
    notifyListeners();
    managementError();
  }

  void reset() {
    messages.clear();
    lotteryProvider.reset();
    currentStep = 0;
    errorCount = 0;
    notifyListeners();
  }

  void rememberBuy() {
    String message = lotteryProvider.messageOfAllLoteries();
    print(message);
    messages.add(Message.create(message, false));
    nextStep();
    notifyListeners();
  }

  void confirmBuy() {
    String lastMessage = messages.last.text;
    if (lastMessage.toLowerCase() == 'si') {
      messages.add(Message.create('Compra confirmada', false));
      nextStep();
      currentStep = 0;
      return;
    }
    if (lastMessage.toLowerCase() == 'no') {
      messages.add(Message.create('Compra cancelada', false));
      reset();
      return;
    }
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
        text: "¿Deseas agregar otro boleto? (sí/no)",
        action: (state) => state.validateSeries()),
    Stepp(text: "", action: (state) => state.canBuyMoreTickets()),
    Stepp(
        text: "¿Deseas confirmar la compra? (si/no)",
        action: (state) => state.rememberBuy()),
    Stepp(text: "Buena Suerte", action: (state) => state.confirmBuy()),
  ];
}
