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
  Lottery lottery = Lottery();
  var currentStep = 0;
  var errorCount = 0;
  var minSeries = 0;
  var maxSeries = 0;

  String identification = '';
  String email = '';
  String phoneNumber = '';
  String name = '';

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
          'http://192.168.1.7:8000/api/v1/lotteries?lotteryName=$lastMessage');
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Failed to load lottery data');
      }

      print('Response body: ${response.body}');
      final Map<String, dynamic> baseData = json.decode(response.body);
      print('baseData: $baseData');

      if (baseData['data'] == null) {
        print('data is null');
        throw Exception('data is null');
      }

      if (!(baseData['data'] is List)) {
        print('data is not a list');
        throw Exception('data is not a list');
      }

      final List<dynamic> data = baseData['data'];
      print('data: $data');

      if (data.isEmpty) {
        messages
            .add(Message.create('La lotería $lastMessage no existe', false));
        _managementError();
        notifyListeners();
        return;
      }

      minSeries = data[0]['minSeries'];
      maxSeries = data[0]['maxSeries'];
      print('minSeries: $minSeries');
      print('maxSeries: $maxSeries');

      lottery.setName(lastMessage);
      messages.add(Message.create('Lotería encontrada: $lastMessage', false));
      _nextStep();
    } catch (error) {
      print('Error: $error');
      messages.add(Message.create('Error al buscar la lotería', false));
      _managementError();
    }
  }

  void createUserData() async {
    try {
      final url =
          Uri.parse('http://192.168.1.7:8000/api/v1/users/create-update');

      Map<String, dynamic> userData = {
        "name": name,
        "document": int.parse(identification),
        "cellphone": phoneNumber,
        "email": email,
      };

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        messages.add(Message.create('Datos creados correctamente', false));
      } else {
        throw Exception('Failed to create user data');
      }
    } catch (error) {
      print('Error: $error');
      messages.add(Message.create('Error al Crear Datos', false));
      _managementError();
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

  void askForIdentification() {
    _nextStep();
  }

  void validateIdentification() {
    String lastMessage = messages.last.text;
    if (!_isValidNumber(lastMessage)) {
      messages.add(Message.create(
          'Identificación no válida, por favor intenta de nuevo', false));
      notifyListeners();
      _managementError();
      return;
    }
    identification = lastMessage;
    _nextStep();
  }

  void askForEmail() {
    String lastMessage = messages.last.text;
    email = lastMessage;
    _nextStep();
  }

  void askForPhoneNumber() {
    String lastMessage = messages.last.text;
    phoneNumber = lastMessage;
    _nextStep();
  }

  void askForName() {
    String lastMessage = messages.last.text;
    name = lastMessage;
    _nextStep();
  }

  void confirmUserInfo() {
    messages.add(Message.create('Identificación: $identification', false));
    messages.add(Message.create('Correo: $email', false));
    messages.add(Message.create('Celular: $phoneNumber', false));
    messages.add(Message.create('Nombre: $name', false));
    String lastMessage = messages.last.text;
    if (lastMessage.toLowerCase() == 'si') {
      createUserData();
      _nextStep();
      notifyListeners();
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
    Stepp(
        text: "Por favor, proporciona tu identificación:",
        action: (state) => state.askForIdentification()),
    Stepp(
        text: "Por favor, proporciona tu correo:",
        action: (state) => state.askForEmail()),
    Stepp(
        text: "Por favor, proporciona tu celular:",
        action: (state) => state.askForPhoneNumber()),
    Stepp(
        text: "Por favor, proporciona tu nombre:",
        action: (state) => state.askForName()),
    Stepp(
        text: "¿Confirmas los siguientes datos? (si/no)",
        action: (state) => state.confirmUserInfo()),
    Stepp(
        text: "¿Deseas confirmar la compra? (si/no)",
        action: (state) => state.rememberBuy()),
    Stepp(text: "Buena Suerte", action: (state) => state.confirmBuy()),
  ];
}
