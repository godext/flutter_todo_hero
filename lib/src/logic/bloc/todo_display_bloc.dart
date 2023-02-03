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
    on<TodoDisplaySetCompleted>(_onTodoDisplaySetCompleted);
  }

  Future<void> _onSubscriptionRequested(
    TodoDisplaySubscriptionRequested event,
    Emitter<TodoDisplayState> emit,
  ) async {
    emit(state.copyWith(status: () => TodoDisplayStatus.loading));

    await emit.forEach<List<Todo>>(_repository.readAllTodo(),
        onData: (todos) => state.copyWith(
              status: () => TodoDisplayStatus.success,
              todos: () => todos,
            ),
        onError: (_, __) =>
            state.copyWith(status: () => TodoDisplayStatus.failure));
  }

  Future<void> _onTodoDisplaySetCompleted(
    TodoDisplaySetCompleted event,
    Emitter<TodoDisplayState> emit,
  ) async {
    try {
      switch (event.todo.isCompleted) {
        case true:
          await _repository.updateTodo(event.todo.copyWith(isCompleted: false));
          break;
        case false:
          await _repository.updateTodo(event.todo.copyWith(isCompleted: true));
          break;
      }
    } catch (e) {
      print('Ist ein Fehler aufgetreten :)');
    }
  }
}
