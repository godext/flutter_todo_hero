import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_hero/src/data/firestore_todo_repository.dart';
import 'package:todo_hero/src/logic/bloc/todo_bloc.dart';
import 'package:todo_hero/src/models/model.dart';
import 'package:todo_hero/src/screens/screens.dart';
import 'package:todo_hero/src/util/widgets/cupertino_scaffold.dart';

@immutable
class TodoEditPage extends StatelessWidget {
  final Todo? initialTodo;

  const TodoEditPage({
    super.key,
    this.initialTodo,
  });

  static Route<void> route(Todo? initialTodo) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => TodoEditPage(initialTodo: initialTodo),
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
          initialTodo: initialTodo,
        ),
        child: CupertinoScaffold(
            title: 'Create To-Do',
            child: Align(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(height: 16),
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
  const _ContentInput();

  void _showAlertDialog(BuildContext context) {
    TodoBloc bloc = BlocProvider.of<TodoBloc>(context);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Delete To-Do'),
        content: const Text('Are you sure you want to delete this To-Do?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              print('Wert von Todo-Id: ${bloc.state.todoId}');
              // TODO: Remove the Route that was created in the TodoEditPage-Class
              //Navigator.of(context).pop();
              bloc.add(TodoDeleted(bloc.state.todoId));
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MainView(),
                ),
                (route) => false,
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      buildWhen: (previous, current) => previous.content != current.content,
      builder: (context, state) {
        return Material(
            child: Container(
          color: CupertinoColors.darkBackgroundGray,
          child: Column(
            children: [
              CupertinoTextFormFieldRow(
                initialValue: state.content,
                placeholderStyle: TextStyle(color: Colors.grey[500]),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    )),
                style: const TextStyle(
                  color: Colors.black,
                ),
                autofocus: true,
                placeholder: 'What are you planning to do?',
                key: const Key('todoForm_todoCreateOrEdit'),
                onChanged: (value) {
                  context.read<TodoBloc>().add(
                        TodoContentChanged(value),
                      );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                child: Column(
                  children: [
                    CupertinoButton.filled(
                      child: Text(state.isNewTodo ? 'Add' : 'Edit'),
                      onPressed: () {
                        context.read<TodoBloc>().add(
                              const TodoSubmitted(),
                            );
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      // If it's not a new todo, this button shall be GONE
                      visible: !state.isNewTodo,
                      child: CupertinoButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            print('ID: ${state.todoId}');
                            print('Content: ${state.content}');
                            return _showAlertDialog(context);
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
      },
    );
  }
}
