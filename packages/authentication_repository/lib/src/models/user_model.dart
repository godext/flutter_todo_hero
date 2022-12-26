import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    this.email,
    this.name,
    this.imageURL,
  });

  final String? email;

  final String id;

  final String? name;

  final String? imageURL;

  static const empty = User(id: '');

  String get userID => this.id;

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name, imageURL];
}
