import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/home_page.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Supabase
  await Supabase.initialize(
    url: 'https://loxtggnrevdiaxlatbmy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxveHRnZ25yZXZkaWF4bGF0Ym15Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzMDUyMjUsImV4cCI6MjA4MDg4MTIyNX0.tupXhDBJZjHj9ajKShQF6JEet0M5lQjdFPesjewJTQo', // Substituir com sua chave
  );

  // Inicializa notificações
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermission();

  runApp(
    ProviderScope(
      overrides: [
        // Usa a instância inicializada do NotificationService
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const AppKillBills(),
    ),
  );
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
