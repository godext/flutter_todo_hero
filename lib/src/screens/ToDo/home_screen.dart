import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_hero/src/data/repositories.dart';
import 'package:todo_hero/src/logic/bloc/app_bloc.dart';
import 'package:todo_hero/src/logic/bloc/todo_bloc.dart';
import 'package:todo_hero/src/logic/bloc/todo_display_bloc.dart';
import 'package:todo_hero/src/screens/ToDo/todo_list_tile.dart';
import 'package:todo_hero/src/screens/screens.dart';
import 'package:todo_hero/src/util/Icons/flutter_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TodoList();
  }
}

class TodoList extends StatelessWidget {
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
          trailing: IconButton(
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
                    return ListView(
                      //physics: const BouncingScrollPhysics(),
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: [
                        for (final todo in state.allTodos)
                          TodoListTile(
                            todo: todo,
                            leading: todo.isCompleted == true
                                ? iconTodoFinished
                                : iconTodoUnfinished,
                            onTapLeading: () =>
                                BlocProvider.of<TodoDisplayBloc>(context).add(
                              TodoDisplayCompletionToggled(
                                todo: todo,
                                isCompleted: !todo.isCompleted,
                              ),
                            ),
                            onTapTodo: () {},
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
                    // code to add a new todo item
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
