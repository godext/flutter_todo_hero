part of 'todo_bloc.dart';

enum TodoStatus { initial, loading, success, failure }

extension TodoStatusX on TodoStatus {
  bool get isLoadingOrSuccess => [
        TodoStatus.loading,
        TodoStatus.success,
      ].contains(this);
}

class TodoState extends Equatable {
  final TodoStatus status;
  final Todo? initialTodo;
  final String content;
  final int timeComplexity;
  final int importancy;
  final int difficulty;
  final int beneficial;

  const TodoState({
    this.status = TodoStatus.initial,
    this.initialTodo,
    this.content = '',
    this.timeComplexity = 0,
    this.importancy = 0,
    this.difficulty = 0,
    this.beneficial = 0,
  });

  bool get isNewTodo => initialTodo == null;

  TodoState copyWith(
      {TodoStatus? status,
      Todo? initialTodo,
      String? content,
      int? timeComplexity,
      int? importancy,
      int? difficulty,
      int? beneficial}) {
    return TodoState(
      status: status ?? this.status,
      initialTodo: initialTodo ?? this.initialTodo,
      content: content ?? this.content,
      timeComplexity: timeComplexity ?? this.timeComplexity,
      importancy: importancy ?? this.importancy,
      difficulty: difficulty ?? this.difficulty,
      beneficial: beneficial ?? this.beneficial,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialTodo,
        content,
        timeComplexity,
        importancy,
        difficulty,
        beneficial,
      ];
}
