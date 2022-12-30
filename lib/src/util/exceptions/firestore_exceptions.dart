class FirestoreTodoException implements Exception {
  const FirestoreTodoException([
    this.message = 'An unknown exception occurred.',
  ]);

  factory FirestoreTodoException.fromCode(String code, [Object? errorMessage]) {
    switch (code) {
      case 'todo-empty':
        return const FirestoreTodoException('The todo is empty.');
      case 'exception-message':
        return FirestoreTodoException(
            'An error occured: $errorMessage.toString()');
      default:
        return const FirestoreTodoException();
    }
  }

  final String message;
}
