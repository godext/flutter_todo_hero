import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_hero/src/util/constants/firestore_constants/firestore_constants.dart';

class TodoEntity {
  final String content;
  final String dateDue;
  final String id;
  final String userId;
  final int timeComplexity;
  final int importancy;
  final int difficulty;
  final int beneficial;
  final bool isCompleted;

  TodoEntity(
    this.content,
    this.dateDue,
    this.id,
    this.userId,
    this.timeComplexity,
    this.importancy,
    this.difficulty,
    this.beneficial,
    this.isCompleted,
  );

  Map<String, Object> toJson() {
    return {
      todoContent: content,
      todoDateDue: dateDue,
      todoID: id,
      ownerUserIdFieldName: userId,
      todoComplexity: timeComplexity,
      todoImportancy: importancy,
      todoDifficulty: difficulty,
      todoBeneficial: beneficial,
      todoCompleted: isCompleted,
    };
  }

  static TodoEntity fromJson(Map<String, Object> json) {
    return TodoEntity(
      json[todoContent] as String,
      json[todoDateDue] as String,
      json[todoID] as String,
      json[ownerUserIdFieldName] as String,
      json[todoComplexity] as int,
      json[todoImportancy] as int,
      json[todoDifficulty] as int,
      json[todoBeneficial] as int,
      json[todoCompleted] as bool,
    );
  }

  static TodoEntity fromSnapshot(DocumentSnapshot snap) {
    return TodoEntity(
      snap.get(todoContent),
      snap.get(todoDateDue),
      snap.id,
      snap.get(ownerUserIdFieldName),
      snap.get(todoComplexity),
      snap.get(todoImportancy),
      snap.get(todoDifficulty),
      snap.get(todoBeneficial),
      snap.get(todoCompleted),
    );
  }

  Map<String, Object> toDocument() {
    return {
      todoContent: content,
      todoDateDue: dateDue,
      todoID: id,
      ownerUserIdFieldName: userId,
      todoComplexity: timeComplexity,
      todoImportancy: importancy,
      todoDifficulty: difficulty,
      todoBeneficial: beneficial,
      todoCompleted: isCompleted,
    };
  }
}
