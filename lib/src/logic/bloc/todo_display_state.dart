part of 'todo_display_bloc.dart';

enum Status { initial, loading, success, failure }

class TodoDisplayState extends Equatable {
  final Status status;
  final List<Todo> todos;

  const TodoDisplayState({
    this.todos = const [],
    this.status = Status.initial,
  });

  List<Todo> get allTodos => todos;

  TodoDisplayState copyWith({
    Status Function()? status,
    List<Todo> Function()? todos,
  }) {
    return TodoDisplayState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
    );
  }

  @override
  List<Object> get props => [status, todos];
}
