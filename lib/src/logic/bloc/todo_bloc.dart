// ignore_for_file: avoid_print

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_hero/src/data/firestore_todo_repository.dart';
import 'package:todo_hero/src/models/model.dart';
import 'package:uuid/uuid.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final FirestoreTodoRepository _firestoreTodoRepository;
  final AuthenticationRepository _authenticationRepository;

  TodoBloc({
    required FirestoreTodoRepository firestoreTodoRepository,
    required AuthenticationRepository authenticationRepository,
    required Todo? initialTodo,
  })  : _firestoreTodoRepository = firestoreTodoRepository,
        _authenticationRepository = authenticationRepository,
        super(
          TodoState(
            initialTodo: initialTodo,
            content: initialTodo?.content ?? '',
            timeComplexity: initialTodo?.timeComplexity ?? 0,
            importancy: initialTodo?.importancy ?? 0,
            difficulty: initialTodo?.difficulty ?? 0,
            beneficial: initialTodo?.beneficial ?? 0,
          ),
        ) {
    on<TodoContentChanged>(_onTodoContentChanged);
    on<TodoTimeComplexityChanged>(_onTodoTimeComplexityChanged);
    on<TodoImportancyChanged>(_onTodoImportancyChanged);
    on<TodoDifficultyChanged>(_onTodoDifficultyChanged);
    on<TodoBeneficialChanged>(_onTodoBeneficialChanged);
    on<TodoSubmitted>(_onTodoSubmitted);
  }

  void _onTodoContentChanged(
    TodoContentChanged event,
    Emitter<TodoState> emit,
  ) {
    emit(
      state.copyWith(content: event.content),
    );
  }

  void _onTodoTimeComplexityChanged(
    TodoTimeComplexityChanged event,
    Emitter<TodoState> emit,
  ) {
    emit(
      state.copyWith(timeComplexity: event.timeComplexity),
    );
  }

  void _onTodoImportancyChanged(
    TodoImportancyChanged event,
    Emitter<TodoState> emit,
  ) {
    emit(
      state.copyWith(importancy: event.importancy),
    );
  }

  void _onTodoDifficultyChanged(
    TodoDifficultyChanged event,
    Emitter<TodoState> emit,
  ) {
    emit(
      state.copyWith(difficulty: event.difficulty),
    );
  }

  void _onTodoBeneficialChanged(
    TodoBeneficialChanged event,
    Emitter<TodoState> emit,
  ) {
    emit(
      state.copyWith(beneficial: event.beneficial),
    );
  }

  Future<void> _onTodoSubmitted(
    TodoSubmitted event,
    Emitter<TodoState> emit,
  ) async {
    emit(state.copyWith(status: TodoStatus.loading));
    final todo = (state.initialTodo ??
        Todo(
          content: '',
          timeComplexity: 0,
          importancy: 0,
          difficulty: 0,
          beneficial: 0,
          userId: _authenticationRepository.currentUser.id,
          id: const Uuid().toString(),
        ).copyWith(
          content: state.content,
          timeComplexity: state.timeComplexity,
          importancy: state.importancy,
          difficulty: state.difficulty,
          beneficial: state.beneficial,
        ));

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
