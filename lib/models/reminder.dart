import 'package:hive/hive.dart';

part 'reminder.g.dart';

@HiveType(typeId: 0)
class Reminder {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final DateTime dateTime;

  Reminder(this.title, this.dateTime);
}
