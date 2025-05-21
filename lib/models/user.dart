import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 3)  // typeId’ler her model için benzersiz olmalı
class User {
  @HiveField(0)
  final int userID;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String password;

  User({
    required this.userID,
    required this.userName,
    required this.password,
  });
}
