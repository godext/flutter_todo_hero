part of 'todo_create_bloc.dart';

abstract class TodoCreateState extends Equatable {
  const TodoCreateState();
  
  @override
  List<Object> get props => [];
}

class TodoCreateInitial extends TodoCreateState {}
