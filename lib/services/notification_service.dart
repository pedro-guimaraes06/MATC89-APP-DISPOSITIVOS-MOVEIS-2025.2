import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'notification_service.g.dart';

// Serviço para gerenciar notificações locais (Recurso Extra)
class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    
    try {
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );
      debugPrint('✅ NotificationService inicializado com sucesso');
    } catch (e) {
      debugPrint('❌ Erro ao inicializar NotificationService: $e');
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handler para quando usuário toca na notificação
    debugPrint('Notification tapped: ${response.payload}');
  }

  // Solicita permissão (Android 13+)
  Future<bool> requestPermission() async {
    final plugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (plugin != null) {
      try {
        final granted = await plugin.requestNotificationsPermission();
        debugPrint('📱 Permissão de notificações: ${granted == true ? "CONCEDIDA ✅" : "NEGADA ❌"}');
        return granted ?? false;
      } catch (e) {
        debugPrint('❌ Erro ao solicitar permissão de notificações: $e');
        return false;
      }
    }
    debugPrint('📱 Plugin Android não disponível, assumindo permissão concedida');
    return true;
  }

  // Envia notificação imediata
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'bills_channel',
        'Bills Notifications',
        channelDescription: 'Notificações sobre contas a pagar',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const details = NotificationDetails(android: androidDetails);

      await _notifications.show(id, title, body, details, payload: payload);
      debugPrint('🔔 Notificação enviada: $title - $body');
    } catch (e) {
      debugPrint('❌ Erro ao enviar notificação: $e');
      rethrow;
    }
  }

  // Notificação de lembrete de conta
  Future<void> showBillReminder({
    required String billId,
    required String billName,
    required double billValue,
    required int dueDay,
  }) async {
    await showNotification(
      id: billId.hashCode,
      title: '💰 Lembrete de Conta',
      body: '$billName - R\$ ${billValue.toStringAsFixed(2)} vence dia $dueDay',
      payload: billId,
    );
  }

  // Notificação de sucesso
  Future<void> showSuccessNotification(String message) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: '✅ Sucesso',
      body: message,
    );
  }

  // Cancela notificação específica
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  // Cancela todas as notificações
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}

// Provider do serviço de notificações
@riverpod
NotificationService notificationService(Ref ref) {
  return NotificationService();
}
