// Modelo de dados para representar uma conta a pagar
class Bill {
  final String name;    // Nome da conta (ex: "Aluguel", "Luz")
  final double value;   // Valor da conta
  final int dueDay;     // Dia do vencimento (1 a 31)

  // Construtor
  Bill({
    required this.name,
    required this.value,
    required this.dueDay,
  });

  // Converte o objeto Bill para um Map (necessário para salvar no SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'dueDay': dueDay,
    };
  }

  // Cria um objeto Bill a partir de um Map (necessário para carregar do SharedPreferences)
  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      name: json['name'] as String,
      value: json['value'] as double,
      dueDay: json['dueDay'] as int,
    );
  }

  // Método para facilitar debug e visualização no console
  @override
  String toString() {
    return 'Bill(name: $name, value: R\$ $value, dueDay: $dueDay)';
  }
}
