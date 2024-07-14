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

  String document = '';
  String email = '';
  String cellphone = '';
  String name = '';

  bool waitingForUpdateConfirmation = false; // Nuevo estado

  MyAppState({required this.lotteryProvider});

  void addMessage(Message message) {
    messages.add(message);
    if (waitingForUpdateConfirmation) {
      handleUpdateConfirmation(message.text);
    } else {
      steps[currentStep].action(this);
    }
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

  void _goToStep(int step) {
    currentStep = step;
    String text = steps[currentStep].text;
    if (text.isNotEmpty) {
      messages.add(Message.create(text, false));
    }
    errorCount = 0;
    notifyListeners();
  }

  void _reset() {
    messages.clear();
    lotteryProvider.reset();
    currentStep = 0;
    errorCount = 0;
    waitingForUpdateConfirmation = false; // Reinicia el estado
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

      if (response.statusCode != 200) {
        throw Exception('Failed to load lottery data');
      }

      final Map<String, dynamic> baseData = json.decode(response.body);

      if (baseData['data'] == null) {
        throw Exception('data is null');
      }

      if (baseData['data'] is! List) {
        throw Exception('data is not a list');
      }

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
        "document": int.parse(document),
        "cellphone": cellphone,
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
        _nextStep();
      } else {
        currentStep = 4;
        _managementError();
        _nextStep();
      }
    } catch (error) {
      messages.add(Message.create('Error al Crear Datos', false));
      currentStep = 4;
      _nextStep();
    }
  }

  void validateUserData() async {
    try {
      final url =
          Uri.parse('http://192.168.1.7:8000/api/v1/users?document=$document');
      final response = await http.get(url);

      print(response);
      print('Response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Failed to load document data');
      }

      final Map<String, dynamic> baseData = json.decode(response.body);
      print(baseData);

      if (baseData['data'] == null || baseData['data'] is! List) {
        throw Exception('Invalid data format');
      }

      if (baseData['data'].isNotEmpty) {
        messages.add(
            Message.create('¿Quieres actualizar los datos? (si / no)', false));
        notifyListeners();
        waitingForUpdateConfirmation = true; // Espera la confirmación
      } else {
        _nextStep();
      }
    } catch (error) {
      print('Error: $error');
      messages.add(Message.create('Error al Validar Identificacion', false));
      _managementError();
    }
  }

  void handleUpdateConfirmation(String response) {
    if (response.toLowerCase() == 'si') {
      _goToStep(4); // Salta al paso 4
    } else if (response.toLowerCase() == 'no') {
      _goToStep(9); // Salta al paso 9
    } else {
      messages.add(Message.create(
          'Respuesta no válida, por favor responde "si" o "no"', false));
      notifyListeners();
      _managementError();
    }
    waitingForUpdateConfirmation = false; // Restablece la bandera
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
      rememberLoteries();
      _nextStep();
      return;
    }
    messages
        .add(Message.create('Respuesta no valida, vuelve a intentar', false));
    notifyListeners();
    _managementError();
  }

  void rememberLoteries() {
    String message = lotteryProvider.messageOfAllLoteries();
    messages.add(Message.create(message, false));
  }

  void validateIdentification() {
    String lastMessage = messages.last.text;
    if (!_isValidNumber(lastMessage)) {
      messages.add(Message.create('Identificación no válida', false));
      notifyListeners();
      _managementError();
      return;
    }
    document = lastMessage;
    validateUserData();
  }

  void validateEmail() {
    String lastMessage = messages.last.text;
    if (!lastMessage.contains('@')) {
      messages.add(Message.create('Correo no válido', false));
      notifyListeners();
      _managementError();
      return;
    }
    email = lastMessage;
    _nextStep();
  }

  void validateCellphone() {
    String lastMessage = messages.last.text;
    if (!_isValidNumber(lastMessage)) {
      messages.add(Message.create('Celular no válido', false));
      notifyListeners();
      _managementError();
      return;
    }
    cellphone = lastMessage;
    _nextStep();
  }

  void validateName() {
    String lastMessage = messages.last.text;
    if (lastMessage.isEmpty) {
      messages.add(Message.create('Nombre no válido', false));
      notifyListeners();
      _managementError();
      return;
    }
    name = lastMessage;

    String combinedMessage = '''
  Identificación: $document
  Correo: $email
  Celular: $cellphone
  Nombre: $name
  ''';

    messages.add(Message.create(combinedMessage, false));
    _nextStep();
  }

  void confirmUserInfo() {
    String lastMessage = messages.last.text;
    if (lastMessage.toLowerCase() == 'si') {
      createUserData();
      return;
    }
    if (lastMessage.toLowerCase() == 'no') {
      currentStep = 4;
      _nextStep();
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
        action: (state) => state.canBuyMoreTickets()),
    Stepp(
        text: "Por favor, proporciona tu correo:",
        action: (state) => state.validateIdentification()),
    Stepp(
        text: "Por favor, proporciona tu celular:",
        action: (state) => state.validateEmail()),
    Stepp(
        text: "Por favor, proporciona tu nombre:",
        action: (state) => state.validateCellphone()),
    Stepp(
        text: "¿Confirmas los siguientes datos? (si/no)",
        action: (state) => state.validateName()),
    Stepp(
        text: "Se ven los próximos pasos para hacer el pago",
        action: (state) => state.confirmUserInfo())
  ];
}
