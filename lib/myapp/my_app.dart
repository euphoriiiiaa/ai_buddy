import 'package:aichat_uksivt/screens/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:aichat_uksivt/screens/history_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Buddy',
      routes: {
        '/history_page': (context) => const HistoryPage()
      },
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: const TextTheme(
              bodyMedium: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              bodySmall: TextStyle(color: Colors.white30, fontSize: 16))),
      home: const MyHomePage(),
    );
  }
}