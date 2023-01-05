import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_hero/src/logic/bloc/app_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TodoList();
  }
}

class TodoList extends StatelessWidget {
  final List<String> todos = [
    'Auto waschen',
    'Handy putzen',
    'Garten mähen',
    'Auto waschen',
    'Handy putzen',
    'Garten mähen',
    'Auto waschen',
    'Handy putzen',
    'Garten mähen',
    'Auto waschen',
    'Handy putzen',
    'Garten mähen',
    'Auto waschen',
    'Handy putzen',
    'Garten mähen',
    'Auto waschen',
    'Handy putzen',
    'Garten mähen',
  ]; // list of todo items
  // constructor

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
              child: ListView.builder(
                //physics: const BouncingScrollPhysics(),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: CupertinoColors.darkBackgroundGray,
                    child: ListTile(
                      leading: const Icon(
                          CupertinoIcons.check_mark_circled_solid,
                          size: 35,
                          color: CupertinoColors.systemBlue),
                      title: Text(
                        todos[index],
                        style: const TextStyle(
                            fontSize: 20, color: CupertinoColors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: CupertinoButton(
                child: Text('Add Todo',
                    style: TextStyle(
                      color: CupertinoColors.white,
                    )),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    'edit-todo',
                  );
                  // code to add a new todo item
                },
                color: CupertinoColors.systemBlue.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
