import 'package:app/providers/message_provider.dart';

class Stepp {
  final String text;
  final Function(MyAppState) action;

  Stepp({
    required this.text,
    required this.action,
  });
}