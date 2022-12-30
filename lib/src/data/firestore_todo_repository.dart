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

// create todo's
  Future<DocumentReference?> createTodo(Todo todo) async {
    //error-handle
    if (todo.isEmpty) {
      throw FirestoreTodoException.fromCode('todo-empty');
    }

    try {
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

      return docRef;
    } catch (e) {
      FirestoreTodoException.fromCode('exception-message', e);
      return null;
    }
  }

  // read todo's

  Future<List<Todo>> readAllTodo() async {
    String currentUser = _authenticationRepository.currentUser.id;
    late List<Todo> todos = [];
    var docSnapshot = await db.where("UserID", isEqualTo: currentUser).get();
    for (var i in docSnapshot.docs) {
      todos.add(fromJson(i.data()));
    }
    return todos;
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
      title: json['title'],
      description: json['description'],
      timeComplexity: json['TimeComplexity'],
      importancy: json['Importancy'],
      difficulty: json['Difficulty'],
      benefital: json['Benefital'],
      isCompleted: json['isCompleted'],
    );
  }
}
