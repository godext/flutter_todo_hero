import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_hero/src/logic/bloc/todo_edit_bloc.dart';

class CustomCupertinoSegmentedControl extends StatelessWidget {
  const CustomCupertinoSegmentedControl({
    Key? key,
    required this.todoEditBloc,
    required this.onValueChanged,
  }) : super(key: key);

  final Function(int value) onValueChanged;
  final TodoEditBloc todoEditBloc;

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<int>(
      backgroundColor: CupertinoColors.systemGrey2,
      groupValue: todoEditBloc.state.timeComplexity == 0
          ? 1
          : todoEditBloc.state.timeComplexity,
      thumbColor: CupertinoColors.systemBlue,
      onValueChanged: (int? value) {
        if (value != null) {
          //selectedSegment = value;
          onValueChanged(value);
        }
      },
      children: Map.fromEntries(
        List.generate(
          5,
          (index) => MapEntry(
            index + 1,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: CupertinoColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}