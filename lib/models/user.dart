import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'user.g.dart';

//User Model

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  @HiveField(4, defaultValue: false)
  final bool isAdmin;

  User(
      {required this.name,
      required this.email,
      required this.password,
      required this.isAdmin})
      : id = const Uuid().v4(); //Random string generator
}
