import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Todo extends Equatable {
  final String title;
  final String description;
  final DateTime? dateDue;
  final String? id;
  final String? userId;
  final int? timeComplexity;
  final int? importancy;
  final int? difficulty;
  final int? benefital;

  const Todo({
    required this.title,
    required this.description,
    this.dateDue,
    this.id,
    this.userId,
    this.timeComplexity,
    this.importancy,
    this.difficulty,
    this.benefital,
  });

  static const empty = Todo(
    title: '',
    description: '',
  );

  bool get isEmpty => this == Todo.empty;

  bool get isNotEmpty => this != Todo.empty;

  Map<String, dynamic> toJson(Todo todo) {
    return {
      "ID": todo.id,
      "UserID": todo.userId,
      "Title": todo.title,
      "Description": todo.description,
      "TimeComplexity": todo.timeComplexity,
      "Importancy": todo.importancy,
      "Difficulty": todo.difficulty,
      "Benefital": todo.benefital
    };
  }

  Todo copyWith({
    String? title,
    String? description,
    String? userId,
    String? id,
    DateTime? dateDue,
    int? timeComplexity,
    int? importancy,
    int? difficulty,
    int? benefital,
  }) {
    return Todo(
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      id: id ?? this.id,
      dateDue: dateDue ?? this.dateDue,
      timeComplexity: timeComplexity ?? this.timeComplexity,
      importancy: importancy ?? this.importancy,
      difficulty: difficulty ?? this.difficulty,
      benefital: benefital ?? this.benefital,
    );
  }

  @override
  List<Object?> get props => [title, description, id, userId];
}