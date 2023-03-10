part of 'todo_display_bloc.dart';

abstract class TodoDisplayEvent extends Equatable {
  const TodoDisplayEvent();

  @override
  List<Object?> get props => [];
}

class TodoDisplaySubscriptionRequested extends TodoDisplayEvent {
  const TodoDisplaySubscriptionRequested();
}

class TodoDisplayCompletionToggled extends TodoDisplayEvent {
  const TodoDisplayCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });
  final Todo todo;
  final bool isCompleted;

  @override
  List<Object?> get props => [todo, isCompleted];
}

class TodoDisplayDismissed extends TodoDisplayEvent {
  const TodoDisplayDismissed({
    required this.todo,
  });

  final Todo todo;

  @override
  // TODO: implement props
  List<Object?> get props => [todo];
}
