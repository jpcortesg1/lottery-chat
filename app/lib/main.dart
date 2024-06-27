import 'package:app/providers/lottery_provider.dart';
import 'package:app/providers/message_provider.dart';
import 'package:app/screens/chat_screen.dart';
// import 'package:app/screens/home_page.dart';
// import 'package:app/screens/login_page.dart';
import 'package:app/theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => LotteryProvider()),
    ChangeNotifierProxyProvider<LotteryProvider, MyAppState>(
      create: (context) => MyAppState(
          lotteryProvider:
              Provider.of<LotteryProvider>(context, listen: false)),
      update: (context, lotteryProvider, previous) =>
          MyAppState(lotteryProvider: lotteryProvider),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ChatPage(),
      theme: lightMode,
    );
  }
}
