import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const AppKillBills());
}

class AppKillBills extends StatelessWidget {
  const AppKillBills({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kill Bills',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
