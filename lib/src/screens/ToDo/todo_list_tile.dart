import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_hero/src/models/model.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    required this.todo,
    super.key,
    required this.leading,
    this.onTapTodo,
    this.onTapLeading,
  });

  final Todo todo;
  final VoidCallback? onTapTodo;
  final VoidCallback? onTapLeading;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    print('build-method TodoListTile');
    return ListTile(
      onTap: onTapTodo,
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
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
      leading: IconButton(
        icon: this.leading,
        onPressed: onTapLeading,
      ),
    );
  }
}

extension StringExtension on String {
  String truncateTo(int maxLength) =>
      (length <= maxLength) ? this : '${substring(0, maxLength)}...';
}
