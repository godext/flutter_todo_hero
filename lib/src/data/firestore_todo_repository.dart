import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_hero/src/Entities/entities.dart';
import 'package:todo_hero/src/models/model.dart';
import 'package:todo_hero/src/util/constants/firestore_constants/firestore_constants.dart';
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
    try {
      // Check that the todo is not empty
      if (todo.isEmpty) {
        throw FirestoreTodoException.fromCode('todo-empty');
      }

      // Set the todo ID and user ID (if not already set)
      final todoID = const Uuid().v4();
      final userID = todo.userId ?? _authenticationRepository.currentUser.id;
      todo = todo.copyWith(id: todoID, userId: userID);

      // Add the todo to the database and return the document reference
      final documentReference = await db.add(
        todo.toJson(todo),
      );
      return documentReference;
    } catch (e) {
      // Handle any errors that occur during the process
      throw FirestoreTodoException.fromCode('exception-message', e.toString());
    }
  }

  Stream<List<Todo>> readAllTodo() {
    return db.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Todo.fromEntity(TodoEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  Stream<List<Todo>> readTodoByUser() {
    final currentUserID = _authenticationRepository.currentUser.userID;
    return db
        .where(ownerUserIdFieldName, isEqualTo: currentUserID)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Todo.fromEntity(TodoEntity.fromSnapshot(doc)))
            .toList());
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

  Future<void> deleteTodo(String documentId) async {
    try {
      // Check that the document ID is not empty
      if (documentId.isEmpty) {
        throw FirestoreTodoException.fromCode('todo-empty');
      }

      // Delete the todo from the database
      await db.doc(documentId).delete();
    } catch (e) {
      // Handle any errors that occur during the process
      throw FirestoreTodoException.fromCode('delete-todo-error', e.toString());
    }
  }
}
