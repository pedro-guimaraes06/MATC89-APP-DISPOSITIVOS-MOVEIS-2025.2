
// Modelo de dados para representar uma conta a pagar (N lado da relação 1:N)
class Bill {
  final String? id;
  final String name;
  final double value;
  final int dueDay;
  final String categoryId; // FK para Category
  final bool isPaid;
  final DateTime createdAt;

  Bill({
    this.id,
    required this.name,
    required this.value,
    required this.dueDay,
    required this.categoryId,
    this.isPaid = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Converte o objeto Bill para um Map (Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'value': value,
      'due_day': dueDay,
      'category_id': categoryId,
      'is_paid': isPaid,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Cria um objeto Bill a partir de um Map (Supabase)
  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] as String?,
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      dueDay: json['due_day'] as int,
      categoryId: json['category_id'] as String,
      isPaid: json['is_paid'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Bill copyWith({
    String? id,
    String? name,
    double? value,
    int? dueDay,
    String? categoryId,
    bool? isPaid,
    DateTime? createdAt,
  }) {
    return Bill(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      dueDay: dueDay ?? this.dueDay,
      categoryId: categoryId ?? this.categoryId,
      isPaid: isPaid ?? this.isPaid,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Bill(id: $id, name: $name, value: R\$ $value, dueDay: $dueDay, categoryId: $categoryId, isPaid: $isPaid)';
  }
}
