part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class TodoContentChanged extends TodoEvent {
  const TodoContentChanged(this.content);

  final String content;

  @override
  List<Object> get props => [content];
}

class TodoTimeComplexityChanged extends TodoEvent {
  final int timeComplexity;

  const TodoTimeComplexityChanged(this.timeComplexity);

  @override
  List<Object> get props => [timeComplexity];
}

class TodoImportancyChanged extends TodoEvent {
  final int importancy;

  const TodoImportancyChanged(this.importancy);

  @override
  List<Object> get props => [importancy];
}

class TodoDifficultyChanged extends TodoEvent {
  final int difficulty;

  const TodoDifficultyChanged(this.difficulty);

  @override
  List<Object> get props => [difficulty];
}

class TodoBeneficialChanged extends TodoEvent {
  final int beneficial;

  const TodoBeneficialChanged(this.beneficial);

  @override
  List<Object> get props => [beneficial];
}

class TodoSubmitted extends TodoEvent {
  const TodoSubmitted();

  @override
  List<Object> get props => [];
}
