class FirestoreTodoException implements Exception {
  const FirestoreTodoException([
    this.message = 'An unknown exception occurred.',
  ]);

  factory FirestoreTodoException.fromCode(String code) {
    switch (code) {
      case 'todo-empty':
        return const FirestoreTodoException('The todo is empty.');
      default:
        return const FirestoreTodoException();
    }
  }

  final String message;
}
