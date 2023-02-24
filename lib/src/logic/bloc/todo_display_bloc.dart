import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_hero/src/data/firestore_todo_repository.dart';
import 'package:todo_hero/src/models/model.dart';
import 'dart:developer';

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
    on<TodoDisplayFilterSet>(_onTodoFilterSet);
  }

  Future<void> _onTodoFilterSet(
    TodoDisplayFilterSet event,
    Emitter<TodoDisplayState> emit,
  ) async {
    log("before setting filter: ${state.filter.toString()}");
    emit(
      state.copyWith(
        status: () => TodoDisplayStatus.loading,
        filter: () => event.filter,
      ),
    );

    log("after setting filter: ${state.filter.toString()}");

    await emit.forEach<List<Todo>>(_repository.readTodoByFilter(event.filter),
        onData: (todos) => state.copyWith(
              status: () => TodoDisplayStatus.success,
              todos: () => todos,
              filter: () => event.filter,
            ),
        onError: (_, __) => state.copyWith(
              status: () => TodoDisplayStatus.failure,
            ));

    log("after reading the filtered list: ${state.filter.toString()}");
  }

  Future<void> _onSubscriptionRequested(
    TodoDisplaySubscriptionRequested event,
    Emitter<TodoDisplayState> emit,
  ) async {
    emit(state.copyWith(status: () => TodoDisplayStatus.loading));

    log("Im Subscription Requested ${state.filter.toString()}");

    await emit.forEach<List<Todo>>(_repository.readTodoByFilter(state.filter),
        onData: (todos) => state.copyWith(
              status: () => TodoDisplayStatus.success,
              todos: () => todos,
              filter: () => state.filter,
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
      log("Nach dem completion-toggled: ${state.filter.toString()}");
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
      log(state.filter.toString());
    } catch (e) {
      print('Fehler beim dismissen der To-Do von der Front-View');
    }
  }
}
