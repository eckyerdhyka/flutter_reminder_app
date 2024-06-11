import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/bloc/reminder_event.dart';
import 'package:reminder_app/bloc/reminder_state.dart';
import 'package:hive/hive.dart';
import 'package:reminder_app/models/reminder.dart';
import 'package:reminder_app/services/notification_service.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final Box box;

  ReminderBloc(this.box) : super(ReminderInitial()) {
    on<AddReminder>(_onAddReminder);
    on<UpdateReminder>(_onUpdateReminder);
    on<RemoveReminder>(_onRemoveReminder);
    _loadReminders();
  }

  void _loadReminders() {
    final reminders = box.values.cast<Reminder>().toList();
    emit(ReminderLoaded(reminders));
  }

  Future<void> _onAddReminder(AddReminder event, Emitter<ReminderState> emit) async {
    final reminder = Reminder(event.title, event.dateTime);
    final int id = await box.add(reminder);  // Await here
    if (!kIsWeb) {
      await NotificationService().scheduleNotification(id, event.title, 'Reminder', event.dateTime);
    }
    final reminders = box.values.cast<Reminder>().toList();
    emit(ReminderLoaded(reminders));
  }

  void _onRemoveReminder(RemoveReminder event, Emitter<ReminderState> emit) {
    box.deleteAt(event.index);
    if (!kIsWeb) {
      NotificationService().cancelNotification(event.index);
    }
    final reminders = box.values.cast<Reminder>().toList();
    emit(ReminderLoaded(reminders));
  }

  void _onUpdateReminder(UpdateReminder event, Emitter<ReminderState> emit) {
    final updatedReminder = Reminder(event.title, event.dateTime);
    box.putAt(event.id, updatedReminder);
    if (!kIsWeb) {
      NotificationService().scheduleNotification(event.id, event.title, 'Reminder', event.dateTime);
    }
    final reminders = box.values.cast<Reminder>().toList();
    emit(ReminderLoaded(reminders));
  }
}
