import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Todo extends Equatable {
  final String content;
  final DateTime? dateDue;
  final String? id;
  final String? userId;
  final int? timeComplexity;
  final int? importancy;
  final int? difficulty;
  final int? beneficial;
  final bool? isCompleted;

  const Todo({
    required this.content,
    this.dateDue,
    this.id,
    this.userId,
    this.timeComplexity,
    this.importancy,
    this.difficulty,
    this.beneficial,
    this.isCompleted,
  });

  static const empty = Todo(
    content: '',
  );

  bool get isEmpty => this == Todo.empty;

  bool get isNotEmpty => this != Todo.empty;

  Map<String, dynamic> toJson(Todo todo) {
    return {
      "ID": todo.id,
      "UserID": todo.userId,
      "Content": todo.content,
      "TimeComplexity": todo.timeComplexity,
      "Importancy": todo.importancy,
      "Difficulty": todo.difficulty,
      "Beneficial": todo.beneficial,
      "isCompleted": todo.isCompleted,
    };
  }

  Todo copyWith({
    String? content,
    String? userId,
    String? id,
    DateTime? dateDue,
    int? timeComplexity,
    int? importancy,
    int? difficulty,
    int? beneficial,
    bool? isCompleted,
  }) {
    return Todo(
      content: content ?? this.content,
      userId: userId ?? this.userId,
      id: id ?? this.id,
      dateDue: dateDue ?? this.dateDue,
      timeComplexity: timeComplexity ?? this.timeComplexity,
      importancy: importancy ?? this.importancy,
      difficulty: difficulty ?? this.difficulty,
      beneficial: beneficial ?? this.beneficial,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [content, id, userId];
}
