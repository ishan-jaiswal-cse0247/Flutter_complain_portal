import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'complaint.g.dart';

//Complaint Model

@HiveType(typeId: 1)
class Complaint {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3, defaultValue: 0)
  final int level;

  @HiveField(4, defaultValue: false)
  final bool isSolved;

  @HiveField(5)
  final String postedBy;

  Complaint({
    required this.title,
    required this.description,
    required this.level,
    required this.isSolved,
    required this.postedBy,
  }) : id = const Uuid().v4(); //Random string generator
}
