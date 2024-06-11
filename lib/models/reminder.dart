import 'package:hive/hive.dart';

part 'reminder.g.dart';

@HiveType(typeId: 0)
class Reminder {
  static int _nextId = 1;
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime dateTime;

  Reminder(this.title, this.dateTime) : id = _nextId++;
}
