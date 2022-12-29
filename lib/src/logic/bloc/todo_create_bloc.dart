import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'todo_create_event.dart';
part 'todo_create_state.dart';

class TodoCreateBloc extends Bloc<TodoCreateEvent, TodoCreateState> {
  TodoCreateBloc() : super(TodoCreateInitial()) {
    on<TodoCreateEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
