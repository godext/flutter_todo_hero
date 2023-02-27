import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_hero/src/data/firestore_todo_repository.dart';
import 'package:todo_hero/src/logic/bloc/todo_edit_bloc.dart';
import 'package:todo_hero/src/models/model.dart';
import 'package:todo_hero/src/screens/screens.dart';
import 'package:todo_hero/src/util/widgets/widgets.dart';

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
        create: (context) => TodoEditBloc(
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
                    SizedBox(height: 20),
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
    TodoEditBloc bloc = BlocProvider.of<TodoEditBloc>(context);

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
    final TodoEditBloc todoEditBloc = context.read<TodoEditBloc>();

    return BlocBuilder<TodoEditBloc, TodoEditState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return WillPopScope(
          onWillPop: (() async {
            todoEditBloc.add(const TodoSubmitted());
            return true;
          }),
          child: Material(
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              color: CupertinoColors.darkBackgroundGray,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Title',
                          style: TextStyle(color: CupertinoColors.white)),
                      const SizedBox(height: 10),
                      CupertinoTextFormFieldRow(
                        padding: const EdgeInsetsDirectional.all(0),
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
                          todoEditBloc.add(
                            TodoContentChanged(value),
                          );
                        },
                      ),
                    ],
                  ),
                  // Difficulty
                  const SizedBox(height: 25),
                  const Text('Difficulty',
                      style: TextStyle(color: CupertinoColors.white)),
                  const SizedBox(height: 10),
                  // Difficulty
                  CustomCupertinoSegmentedControl(
                    todoEditBloc: todoEditBloc,
                    groupValue: todoEditBloc.state.difficulty == 0
                        ? 1
                        : todoEditBloc.state.difficulty,
                    onValueChanged: (value) => todoEditBloc.add(
                      TodoDifficultyChanged(value),
                    ),
                  ),

                  const SizedBox(height: 25),
                  const Text('Time complexity',
                      style: TextStyle(color: CupertinoColors.white)),
                  const SizedBox(height: 10),
                  // TimeComplexity
                  CustomCupertinoSegmentedControl(
                    todoEditBloc: todoEditBloc,
                    groupValue: todoEditBloc.state.timeComplexity == 0
                        ? 1
                        : todoEditBloc.state.timeComplexity,
                    onValueChanged: (value) => todoEditBloc.add(
                      TodoTimeComplexityChanged(value),
                    ),
                  ),

                  const SizedBox(height: 25),
                  const Text('Added Value',
                      style: TextStyle(color: CupertinoColors.white)),
                  const SizedBox(height: 10),
                  // Beneficial
                  CustomCupertinoSegmentedControl(
                    todoEditBloc: todoEditBloc,
                    groupValue: todoEditBloc.state.beneficial == 0
                        ? 1
                        : todoEditBloc.state.beneficial,
                    onValueChanged: (value) => todoEditBloc.add(
                      TodoBeneficialChanged(value),
                    ),
                  ),

                  const SizedBox(height: 25),
                  const Text('Importancy',
                      style: TextStyle(color: CupertinoColors.white)),
                  const SizedBox(height: 10),
                  // Beneficial
                  CustomCupertinoSegmentedControl(
                    todoEditBloc: todoEditBloc,
                    groupValue: todoEditBloc.state.importancy == 0
                        ? 1
                        : todoEditBloc.state.importancy,
                    onValueChanged: (value) => todoEditBloc.add(
                      TodoImportancyChanged(value),
                    ),
                  ),

                  const SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: Column(
                      children: [
                        CupertinoButton.filled(
                          child: Text(state.isNewTodo ? 'Add' : 'Edit'),
                          onPressed: () {
                            todoEditBloc.add(
                              const TodoSubmitted(),
                            );
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: 20),
                        Visibility(
                          // If it's not a new todo, this button shall be GONE
                          visible: !state.isNewTodo,
                          child: CupertinoButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              return _showAlertDialog(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
