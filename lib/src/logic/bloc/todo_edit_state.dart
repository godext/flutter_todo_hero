part of 'todo_edit_bloc.dart';

enum TodoStatus { initial, loading, success, failure }

extension TodoStatusX on TodoStatus {
  bool get isLoadingOrSuccess => [
        TodoStatus.loading,
        TodoStatus.success,
      ].contains(this);
}

class TodoEditState extends Equatable {
  final TodoStatus status;
  final Todo? initialTodo;
  final String content;
  final String dueDate;
  final int timeComplexity;
  final int importancy;
  final int difficulty;
  final int beneficial;
  final String todoId;
  final bool isCompleted;

  const TodoEditState({
    this.status = TodoStatus.initial,
    this.initialTodo,
    this.content = '',
    this.dueDate = '',
    this.timeComplexity = 1,
    this.importancy = 1,
    this.difficulty = 1,
    this.beneficial = 1,
    this.todoId = '',
    this.isCompleted = false,
  });

  bool get isNewTodo => initialTodo == null;

  TodoEditState copyWith({
    TodoStatus? status,
    Todo? initialTodo,
    String? content,
    String? dueDate,
    int? timeComplexity,
    int? importancy,
    int? difficulty,
    int? beneficial,
    String? todoId,
    bool? isCompleted,
  }) {
    return TodoEditState(
      status: status ?? this.status,
      initialTodo: initialTodo ?? this.initialTodo,
      content: content ?? this.content,
      dueDate: dueDate ?? DateTime.now().toString(),
      timeComplexity: timeComplexity ?? this.timeComplexity,
      importancy: importancy ?? this.importancy,
      difficulty: difficulty ?? this.difficulty,
      beneficial: beneficial ?? this.beneficial,
      todoId: todoId ?? this.todoId,
      isCompleted: isCompleted ?? this.isCompleted,
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
        todoId,
        isCompleted
      ];
}
