import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bill.dart';

// Classe responsável por salvar e carregar as contas do armazenamento local
class BillStorage {
  // Chave usada para salvar/carregar as contas no SharedPreferences
  static const String _storageKey = 'bills_list';

  // Carrega todas as contas salvas
  Future<List<Bill>> loadBills() async {
    final prefs = await SharedPreferences.getInstance();
    final String? billsJson = prefs.getString(_storageKey);

    // Se não há dados salvos, retorna lista vazia
    if (billsJson == null) {
      return [];
    }

    // Converte o JSON string para lista de Maps
    final List<dynamic> billsList = jsonDecode(billsJson);

    // Converte cada Map para um objeto Bill
    return billsList.map((billMap) => Bill.fromJson(billMap)).toList();
  }

  // Salva a lista de contas
  Future<void> saveBills(List<Bill> bills) async {
    final prefs = await SharedPreferences.getInstance();

    // Converte a lista de Bills para lista de Maps
    final List<Map<String, dynamic>> billsList =
        bills.map((bill) => bill.toJson()).toList();

    // Converte para JSON string e salva
    final String billsJson = jsonEncode(billsList);
    await prefs.setString(_storageKey, billsJson);
  }

  // Adiciona uma nova conta à lista existente
  Future<void> addBill(Bill bill) async {
    final bills = await loadBills();
    bills.add(bill);
    await saveBills(bills);
  }

  // Remove uma conta da lista pelo índice
  Future<void> removeBill(int index) async {
    final bills = await loadBills();
    if (index >= 0 && index < bills.length) {
      bills.removeAt(index);
      await saveBills(bills);
    }
  }

  // Limpa todas as contas (útil para testes)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
