import 'package:app/providers/message.dart';
import 'package:app/screens/chat_screen.dart';
// import 'package:app/screens/home_page.dart';
// import 'package:app/screens/login_page.dart';
import 'package:app/theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChatPage(),
        theme: lightMode,
      ),
    );
  }
}

