import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_hero/src/logic/bloc/app_bloc.dart';
import 'package:todo_hero/src/logic/bloc/todo_bloc.dart';
import 'package:todo_hero/src/models/model.dart';
import 'package:todo_hero/src/screens/ToDo/home_screen.dart';
import 'package:todo_hero/src/screens/screens.dart';
import 'package:todo_hero/src/util/routes.dart';

class ToDoApp extends StatelessWidget {
  ToDoApp({
    super.key,
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  Todo initialTodo = const Todo(
    content: '',
    isCompleted: false,
  );

  final AuthenticationRepository _authenticationRepository;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
        ),
        child: const ToDoAppView(),
      ),
    );
  }
}

class ToDoAppView extends StatelessWidget {
  const ToDoAppView({super.key});

  @override
  Widget build(BuildContext context) {
    print('Bin jetzt in der ToDoAppView');

    return MaterialApp(
      title: 'To-Do-Hero',
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
