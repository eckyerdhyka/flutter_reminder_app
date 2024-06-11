import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reminder_app/app.dart';
import 'package:reminder_app/models/reminder.dart';
import 'package:reminder_app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ReminderAdapter());
  await Hive.openBox('reminders');
  await NotificationService().init();  // Initialize the notification service
  runApp(ReminderApp());
}
