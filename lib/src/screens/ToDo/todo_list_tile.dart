import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_hero/src/models/model.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    required this.todo,
    this.onTap,
    super.key,
    this.leading,
  });

  final Todo todo;
  final VoidCallback? onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    print('build-method TodoListTile');
    return ListTile(
      onTap: onTap,
      title: Text(
        todo.content.truncateTo(
          20,
        ),
        style: const TextStyle(
          fontSize: 20,
          color: CupertinoColors.white,
        ),
      ),
      subtitle: Text(
        todo.dateDue.toString(),
      ),
      tileColor: Colors.grey[800],
      leading: leading,
    );
  }
}

extension StringExtension on String {
  String truncateTo(int maxLength) =>
      (this.length <= maxLength) ? this : '${this.substring(0, maxLength)}...';
}
