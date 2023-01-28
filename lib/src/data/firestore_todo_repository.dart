import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_hero/src/models/model.dart';
import 'package:todo_hero/src/util/exceptions/custom_exceptions.dart';
import 'package:uuid/uuid.dart';

class FirestoreTodoRepository {
  late AuthenticationRepository _authenticationRepository;

  // Create singleton
  static final FirestoreTodoRepository _inst =
      FirestoreTodoRepository._internal();

  FirestoreTodoRepository._internal();

  factory FirestoreTodoRepository(
      AuthenticationRepository authenticationRepository) {
    _inst._authenticationRepository = authenticationRepository;
    return _inst;
  }

  final db = FirebaseFirestore.instance.collection('todo');

// create todo's
  Future<DocumentReference?> createTodo(Todo todo) async {
    //error-handle
    if (todo.isEmpty) {
      throw FirestoreTodoException.fromCode('todo-empty');
    }

    try {
      final String todoID = const Uuid().v4();
      //var docRef = db.doc();
      String? userID;

      if (todo.userId == null) {
        userID = _authenticationRepository.currentUser.id;
      }

      todo = todo.copyWith(
        id: todoID,
        userId: userID,
      );

      return db.add(todo.toJson(todo));
    } catch (e) {
      FirestoreTodoException.fromCode('exception-message', e);
      return null;
    }
  }

  // read todo's

  Stream<List<Todo>> readAllTodo() {
    return db.snapshots().map(
          (snapShot) => snapShot.docs
              .map((document) => fromJson(document.data()))
              .toList(),
        );
  }

// update todo's
  Future<void> updateTodo(Todo todo) async {
    if (todo.isEmpty) {
      throw FirestoreTodoException.fromCode('todo-empty');
    }

    try {
      db.doc(todo.id).update(todo.toJson(todo));
      return;
    } catch (e) {
      throw FirestoreTodoException.fromCode('exception-message', e);
    }
  }

// Delete todo's
  Future<void> deleteTodo(Todo todo) async {
    if (todo.isEmpty) {
      throw FirestoreTodoException.fromCode('todo-empty');
    }

    try {
      db.doc(todo.id).delete();
    } catch (e) {
      throw FirestoreTodoException.fromCode('exception-message', e);
    }
  }

// transform JSON to Todo-Object
  Todo fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['ID'],
      userId: json['UserID'],
      content: json['description'],
      timeComplexity: json['TimeComplexity'],
      importancy: json['Importancy'],
      difficulty: json['Difficulty'],
      isCompleted: json['isCompleted'],
    );
  }
}
