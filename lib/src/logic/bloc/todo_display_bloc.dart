import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_hero/src/data/firestore_todo_repository.dart';
import 'package:todo_hero/src/models/model.dart';

part 'todo_display_event.dart';
part 'todo_display_state.dart';

class TodoDisplayBloc extends Bloc<TodoDisplayEvent, TodoDisplayState> {
  final FirestoreTodoRepository _repository;

  TodoDisplayBloc({required FirestoreTodoRepository repository})
      : _repository = repository,
        super(const TodoDisplayState()) {
    on<TodoDisplaySubscriptionRequested>(_onSubscriptionRequested);
    on<TodoDisplayCompletionToggled>(_onTodoCompletionToggled);
    on<TodoDisplayDismissed>(_onTodoDismissed);
  }

  Future<void> _onSubscriptionRequested(
    TodoDisplaySubscriptionRequested event,
    Emitter<TodoDisplayState> emit,
  ) async {
    emit(state.copyWith(status: () => TodoDisplayStatus.loading));

    await emit.forEach<List<Todo>>(_repository.readTodoByUser(),
        onData: (todos) => state.copyWith(
              status: () => TodoDisplayStatus.success,
              todos: () => todos,
            ),
        onError: (_, __) =>
            state.copyWith(status: () => TodoDisplayStatus.failure));
  }

  Future<void> _onTodoCompletionToggled(
    TodoDisplayCompletionToggled event,
    Emitter<TodoDisplayState> emit,
  ) async {
    try {
      final newTodo = event.todo.copyWith(isCompleted: event.isCompleted);
      await _repository.updateTodo(newTodo);
    } catch (e) {
      print('Ist ein Fehler aufgetreten :)');
    }
  }

  Future<void> _onTodoDismissed(
    TodoDisplayDismissed event,
    Emitter<TodoDisplayState> emit,
  ) async {
    try {
      await _repository.deleteTodo(event.todo.id!);
    } catch (e) {
      print('Fehler beim dismissen der To-Do von der Front-View');
    }
  }
}
