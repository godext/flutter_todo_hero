import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_hero/src/models/model.dart';

class FirestoreCRUDTodoException implements Exception {
  const FirestoreCRUDTodoException([
    this.message = 'An unknown exception occurred.',
  ]);

  factory FirestoreCRUDTodoException.fromCode(String code) {
    switch (code) {
      case 'todo-empty':
        return const FirestoreCRUDTodoException('The todo is empty.');
      default:
        return const FirestoreCRUDTodoException();
    }
  }

  final String message;
}

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

  Future<void> addTodo(Todo todo) async {
    if (todo.isEmpty) {
      throw FirestoreCRUDTodoException.fromCode('todo-empty');
    }

    var docRef = db.doc();
    String? userID;

    if (todo.userId == null) {
      userID = _authenticationRepository.currentUser.id;
    }

    todo = todo.copyWith(
      id: docRef.id,
      userId: userID,
    );

    db.doc(docRef.id).update(todo.toJson(todo));
  }
}
