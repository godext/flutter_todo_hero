import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_hero/src/data/repositories.dart';
import 'package:todo_hero/src/logic/bloc/app_bloc.dart';
import 'package:todo_hero/src/logic/bloc/todo_display_bloc.dart';
import 'package:todo_hero/src/screens/ToDo/todo_list_tile.dart';
import 'package:todo_hero/src/screens/screens.dart';
import 'package:todo_hero/src/util/Icons/flutter_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TodoList();
  }
}

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoDisplayBloc(
        repository: FirestoreTodoRepository(
          context.read<AuthenticationRepository>(),
        ),
      )..add(
          const TodoDisplaySubscriptionRequested(),
        ),
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        navigationBar: CupertinoNavigationBar(
          middle: const Text('To-Do',
              style: TextStyle(
                fontSize: 28,
                color: CupertinoColors.white,
              )),
          backgroundColor: CupertinoColors.systemBlue,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.slider_horizontal_3),
            color: Colors.white,
            onPressed: () => CupertinoActionSheet(
              title: const Text("Filter To-Do's"),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: ((() {})),
                  child: const Text('Active'),
                ),
                CupertinoActionSheetAction(
                  onPressed: ((() {})),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
          trailing: IconButton(
            color: Colors.white,
            onPressed: () {
              context.read<AppBloc>().add(const AppLogoutRequested());
            },
            icon: const Icon(CupertinoIcons.square_arrow_left),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: BlocBuilder<TodoDisplayBloc, TodoDisplayState>(
                  builder: (context, state) {
                    TodoDisplayBloc displayBloc =
                        BlocProvider.of<TodoDisplayBloc>(context);
                    return ListView(
                      //physics: const BouncingScrollPhysics(),
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: [
                        for (final todo in state.allTodos)
                          Dismissible(
                            key: Key(todo.id!),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                displayBloc
                                    .add(TodoDisplayDismissed(todo: todo));
                              }

                              if (direction == DismissDirection.endToStart) {
                                displayBloc.add(TodoDisplayCompletionToggled(
                                  todo: todo,
                                  isCompleted: !todo.isCompleted,
                                ));
                              }
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.green,
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                Icons.done,
                                color: Colors.white,
                              ),
                            ),
                            child: TodoListTile(
                              todo: todo,
                              leading: todo.isCompleted == true
                                  ? iconTodoFinished
                                  : iconTodoUnfinished,
                              onTapLeading: () => displayBloc.add(
                                TodoDisplayCompletionToggled(
                                  todo: todo,
                                  isCompleted: !todo.isCompleted,
                                ),
                              ),
                              onTapTodo: () => Navigator.of(context).push(
                                TodoEditPage.route(todo),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TodoEditPage(),
                      ),
                    );
                  },
                  color: CupertinoColors.systemBlue.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  child: const Text('Add Todo',
                      style: TextStyle(
                        color: CupertinoColors.white,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
