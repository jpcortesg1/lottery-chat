import 'package:app/main.dart';
import 'package:app/providers/message.dart';

class Stepp {
  final String text;
  final Function(MyAppState) action;

  Stepp({
    required this.text,
    required this.action,
  });
}