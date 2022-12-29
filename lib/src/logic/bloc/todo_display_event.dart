part of 'todo_display_bloc.dart';

abstract class TodoDisplayEvent {
  const TodoDisplayEvent();
}

class TodoDisplayAllEvent extends TodoDisplayEvent {
  const TodoDisplayAllEvent();
}
