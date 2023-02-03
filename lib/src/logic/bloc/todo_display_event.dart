part of 'todo_display_bloc.dart';

abstract class TodoDisplayEvent extends Equatable {
  const TodoDisplayEvent();

  @override
  List<Object?> get props => [];
}

class TodoDisplaySubscriptionRequested extends TodoDisplayEvent {
  const TodoDisplaySubscriptionRequested();
}

class TodoDisplaySetCompleted extends TodoDisplayEvent {
  Todo todo;
  TodoDisplaySetCompleted(this.todo);
}
