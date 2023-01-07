import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_hero/src/data/firestore_todo_repository.dart';
import 'package:todo_hero/src/logic/bloc/todo_bloc.dart';
import 'package:todo_hero/src/util/widgets/cupertino_scaffold.dart';

class TodoEditPage extends StatelessWidget {
  const TodoEditPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => const TodoEditPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FirestoreTodoRepository(
        context.read<AuthenticationRepository>(),
      ),
      child: BlocProvider(
        create: (context) => TodoBloc(
          firestoreTodoRepository: context.read<FirestoreTodoRepository>(),
          authenticationRepository: context.read<AuthenticationRepository>(),
          initialTodo: null,
        ),
        child: CupertinoScaffold(
            title: 'Create To-Do',
            child: Align(
              alignment: const Alignment(0, -1 / 3),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    _ContentInput(),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class _ContentInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      buildWhen: (previous, current) => previous.content != current.content,
      builder: (context, state) {
        return Material(
            child: Container(
          color: CupertinoColors.darkBackgroundGray,
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              CupertinoTextField(
                placeholder: 'What are you planning to do?',
                onChanged: (value) {
                  context.read<TodoBloc>().add(
                        TodoContentChanged(value),
                      );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                child: CupertinoButton.filled(
                  child: const Text('Add'),
                  onPressed: () {
                    context.read<TodoBloc>().add(
                          const TodoSubmitted(),
                        );
                  },
                ),
              ),
            ],
          ),
        ));
      },
    );
  }
}
