import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_hero/src/data/repositories.dart';
import 'package:todo_hero/src/logic/bloc/app_bloc.dart';
import 'package:todo_hero/src/logic/bloc/todo_display_bloc.dart';
import 'package:todo_hero/src/models/model.dart';
import 'package:todo_hero/src/screens/ToDo/todo_list_tile.dart';
import 'package:todo_hero/src/screens/screens.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TodoList();
  }
}

class TodoList extends StatelessWidget {
  const TodoList({super.key, this.errorMessage});

  // Define a private variable to hold the error message
  final String? errorMessage;

  // Define a getter method called 'error' to retrieve the error message
  String? get error => errorMessage;

  // Define a method to set the error message
  void setError(String errorMessage) {
    errorMessage = errorMessage;
  }

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
          leading: BlocBuilder<TodoDisplayBloc, TodoDisplayState>(
            builder: (context, state) {
              TodoDisplayBloc bloc = context.read<TodoDisplayBloc>();
              final filters = [
                {'value': TodoDisplayFilter.all, 'text': 'All'},
                {'value': TodoDisplayFilter.active, 'text': 'Active'},
                {'value': TodoDisplayFilter.done, 'text': 'Done'},
              ];
              return PopupMenuButton<String>(
                icon: const Icon(
                  CupertinoIcons.slider_horizontal_3,
                  color: Colors.white,
                ),
                initialValue: bloc.state.filter.toString(),
                onSelected: (String choice) {},
                itemBuilder: (BuildContext context) {
                  return filters
                      .map((filter) => PopupMenuItem<String>(
                            value: filter['text'] as String?,
                            child: Text(filter['text'] as String,
                                style: TextStyle(
                                  color: bloc.state.filter == filter['value']
                                      ? CupertinoColors.activeBlue
                                      : CupertinoColors.black,
                                )),
                            onTap: () => bloc.add(
                              TodoDisplayFilterSet(
                                  filter: filter['value'] as TodoDisplayFilter),
                            ),
                          ))
                      .toList();
                },
              );
            },
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
                    final displayBloc =
                        BlocProvider.of<TodoDisplayBloc>(context);
                    if (state.status == TodoDisplayStatus.loading) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (state.status == TodoDisplayStatus.failure ||
                        state.allTodos.isEmpty) {
                      return const Center(
                        child: Text("There are no To-Do's right now.", style: TextStyle(
                          color: CupertinoColors.systemGrey, fontSize: 15
                        ),),
                      );
                    } else {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemCount: state.allTodos.length,
                        itemBuilder: (context, index) {
                          final todo = state.allTodos[index];
                          return Dismissible(
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
                          );
                        },
                      );
                    }
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
                  child: const Text(
                    'Add Todo',
                    style: TextStyle(
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
