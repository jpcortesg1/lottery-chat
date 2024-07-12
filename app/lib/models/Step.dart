import 'package:app/providers/message_provider.dart';

/// Represents a step in a process or workflow.
class Stepp {
  final String text;
  late final Function(MyAppState) action;

  Stepp({
    required this.text,
    required this.action,
  });
}