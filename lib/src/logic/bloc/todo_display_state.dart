part of 'todo_display_bloc.dart';

enum TodoDisplayStatus { initial, loading, success, failure }

enum TodoDisplayFilter { all, active, done }

class TodoDisplayState extends Equatable {
  final TodoDisplayStatus status;
  final List<Todo> todos;
  final TodoDisplayFilter filter;

  const TodoDisplayState({
    this.todos = const [],
    this.status = TodoDisplayStatus.initial,
    this.filter = TodoDisplayFilter.active,
  });

  List<Todo> get allTodos => todos;

  TodoDisplayState copyWith({
    TodoDisplayStatus Function()? status,
    List<Todo> Function()? todos,
    TodoDisplayFilter Function()? filter,
  }) {
    return TodoDisplayState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
    );
  }

  @override
  List<Object> get props => [status, todos, filter];
}
