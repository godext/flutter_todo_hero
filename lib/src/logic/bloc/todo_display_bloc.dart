import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_hero/src/models/model.dart';

part 'todo_display_event.dart';
part 'todo_display_state.dart';

class TodoDisplayBloc extends Bloc<TodoDisplayEvent, TodoDisplayState> {
  TodoDisplayBloc() : super(const TodoDisplayState()) {
    on<TodoDisplayEvent>((event, emit) {});
  }
}
