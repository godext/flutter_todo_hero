// ignore_for_file: avoid_print

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_hero/src/data/firestore_todo_repository.dart';
import 'package:todo_hero/src/models/model.dart';

part 'todo_edit_event.dart';
part 'todo_edit_state.dart';

class TodoEditBloc extends Bloc<TodoEditEvent, TodoEditState> {
  final FirestoreTodoRepository _firestoreTodoRepository;
  final AuthenticationRepository _authenticationRepository;

  TodoEditBloc({
    required FirestoreTodoRepository firestoreTodoRepository,
    required AuthenticationRepository authenticationRepository,
    required Todo? initialTodo,
  })  : _firestoreTodoRepository = firestoreTodoRepository,
        _authenticationRepository = authenticationRepository,
        super(
          TodoEditState(
            initialTodo: initialTodo,
            content: initialTodo?.content ?? '',
            timeComplexity: initialTodo?.timeComplexity ?? 1,
            importancy: initialTodo?.importancy ?? 1,
            difficulty: initialTodo?.difficulty ?? 1,
            beneficial: initialTodo?.beneficial ?? 1,
            todoId: initialTodo?.id ?? '',
            isCompleted: initialTodo?.isCompleted ?? false,
          ),
        ) {
    on<TodoContentChanged>(_onTodoContentChanged);
    on<TodoTimeComplexityChanged>(_onTodoTimeComplexityChanged);
    on<TodoImportancyChanged>(_onTodoImportancyChanged);
    on<TodoDifficultyChanged>(_onTodoDifficultyChanged);
    on<TodoBeneficialChanged>(_onTodoBeneficialChanged);
    on<TodoSubmitted>(_onTodoSubmitted);
    on<TodoDeleted>(_onTodoDeleted);
    on<TodoCompletionToggled>(_onTodoCompletionToggled);
  }

  void _onTodoCompletionToggled(
      TodoCompletionToggled event, Emitter<TodoEditState> emit) {
    emit(
      state.copyWith(isCompleted: event.isCompleted),
    );
  }

  void _onTodoDeleted(
    TodoDeleted event,
    Emitter<TodoEditState> emit,
  ) async {
    try {
      await _firestoreTodoRepository.deleteTodo(
        event.todoId,
      );
    } catch (_) {
      print("Deleting didn't work :)");
    }
  }

  void _onTodoContentChanged(
    TodoContentChanged event,
    Emitter<TodoEditState> emit,
  ) {
    emit(
      state.copyWith(content: event.content),
    );
  }

  void _onTodoTimeComplexityChanged(
    TodoTimeComplexityChanged event,
    Emitter<TodoEditState> emit,
  ) {
    emit(
      state.copyWith(timeComplexity: event.timeComplexity),
    );
  }

  void _onTodoImportancyChanged(
    TodoImportancyChanged event,
    Emitter<TodoEditState> emit,
  ) {
    emit(
      state.copyWith(importancy: event.importancy),
    );
  }

  void _onTodoDifficultyChanged(
    TodoDifficultyChanged event,
    Emitter<TodoEditState> emit,
  ) {
    emit(
      state.copyWith(difficulty: event.difficulty),
    );
  }

  void _onTodoBeneficialChanged(
    TodoBeneficialChanged event,
    Emitter<TodoEditState> emit,
  ) {
    emit(
      state.copyWith(beneficial: event.beneficial),
    );
  }

  Future<void> _onTodoSubmitted(
    TodoSubmitted event,
    Emitter<TodoEditState> emit,
  ) async {
    emit(state.copyWith(status: TodoStatus.loading));
    final todo = Todo(
            content: '',
            timeComplexity: 1,
            importancy: 1,
            difficulty: 1,
            beneficial: 1,
            userId: _authenticationRepository.currentUser.id,
            isCompleted: false,
            dateDue: DateTime.now().toString(),
            id: '')
        .copyWith(
      content: state.content,
      timeComplexity: state.timeComplexity,
      importancy: state.importancy,
      difficulty: state.difficulty,
      beneficial: state.beneficial,
      dateDue: state.dueDate,
      id: state.todoId,
      isCompleted: state.isCompleted,
    );

    // Early return wenn der content leer ist
    if (state.content == '') {
      return;
    }

    try {
      if (state.initialTodo == null) {
        print('Erstelle eine neue Todo');
        await _firestoreTodoRepository.createTodo(todo);
      } else {
        print('Update eine bereits existierende todo');
        await _firestoreTodoRepository.updateTodo(todo);
      }

      print('Ist erfolgreich updated/erstellt worden');
      emit(state.copyWith(status: TodoStatus.success));
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(status: TodoStatus.failure));
    }
  }
}
