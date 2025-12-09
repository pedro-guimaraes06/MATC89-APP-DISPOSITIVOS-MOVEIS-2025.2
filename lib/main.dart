import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/home_page.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Supabase
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL', // Substituir com sua URL
    anonKey: 'YOUR_SUPABASE_ANON_KEY', // Substituir com sua chave
  );

  // Inicializa notificações
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermission();

  runApp(
    const ProviderScope(
      child: AppKillBills(),
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
