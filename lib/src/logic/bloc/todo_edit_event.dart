part of 'todo_edit_bloc.dart';

abstract class TodoEditEvent extends Equatable {
  const TodoEditEvent();

  @override
  List<Object> get props => [];
}

class TodoContentChanged extends TodoEditEvent {
  const TodoContentChanged(this.content);

  final String content;

  @override
  List<Object> get props => [content];
}

class TodoTimeComplexityChanged extends TodoEditEvent {
  final int timeComplexity;

  const TodoTimeComplexityChanged(this.timeComplexity);

  @override
  List<Object> get props => [timeComplexity];
}

class TodoImportancyChanged extends TodoEditEvent {
  final int importancy;

  const TodoImportancyChanged(this.importancy);

  @override
  List<Object> get props => [importancy];
}

class TodoDifficultyChanged extends TodoEditEvent {
  final int difficulty;

  const TodoDifficultyChanged(this.difficulty);

  @override
  List<Object> get props => [difficulty];
}

class TodoBeneficialChanged extends TodoEditEvent {
  final int beneficial;

  const TodoBeneficialChanged(this.beneficial);

  @override
  List<Object> get props => [beneficial];
}

class TodoCompletionToggled extends TodoEditEvent {
  final bool isCompleted;

  const TodoCompletionToggled(this.isCompleted);
}

class TodoSubmitted extends TodoEditEvent {
  const TodoSubmitted();

  @override
  List<Object> get props => [];
}

class TodoDeleted extends TodoEditEvent {
  final String todoId;

  const TodoDeleted(this.todoId);

  @override
  List<Object> get props => [];
}
