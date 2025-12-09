import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category.g.dart';

// Modelo de dados para Categoria (1:N com Bill)
class Category {
  final String? id;
  final String name;
  final String icon;
  final String color;
  final DateTime createdAt;

  Category({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Converte para Map (Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Cria a partir de Map (Supabase)
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String?,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Category copyWith({
    String? id,
    String? name,
    String? icon,
    String? color,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, icon: $icon, color: $color)';
  }
}
