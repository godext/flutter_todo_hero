import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_hero/src/models/model.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    required this.todo,
    super.key,
    this.onTapTodo,
    this.onTapLeading,
  });

  final Todo todo;
  final VoidCallback? onTapTodo;
  final VoidCallback? onTapLeading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTapTodo,
      title: Text(
        todo.content,
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
        onPressed: onTapLeading,
        icon: todo.isCompleted == true
            ? const Icon(Icons.check_box, color: CupertinoColors.white)
            : const Icon(Icons.check_box_outline_blank,
                color: CupertinoColors.white),
      ),
    );
  }
}

extension StringExtension on String {
  String truncateTo(int maxLength) =>
      (length <= maxLength) ? this : '${substring(0, maxLength)}...';
}
