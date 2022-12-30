import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_hero/src/models/model.dart';
import 'package:todo_hero/src/util/exceptions/custom_exceptions.dart';

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
    //error-handle
    if (todo.isEmpty) {
      throw FirestoreTodoException.fromCode('todo-empty');
    }

    String? currentUserId = _authenticationRepository.currentUser.id;

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
