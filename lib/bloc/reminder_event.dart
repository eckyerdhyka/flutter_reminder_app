import 'package:equatable/equatable.dart';
import 'package:reminder_app/models/reminder.dart';

abstract class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object> get props => [];
}

class AddReminder extends ReminderEvent {
  final String title;
  final DateTime dateTime;

  const AddReminder(this.title, this.dateTime);

  @override
  List<Object> get props => [title, dateTime];
}

class UpdateReminder extends ReminderEvent {
  final int id;
  final String title;
  final DateTime dateTime;
  
  const UpdateReminder(this.id,this.title, this.dateTime);

  @override
  List<Object> get props => [id,title, dateTime];
}


class RemoveReminder extends ReminderEvent {
  final int index;

  const RemoveReminder(this.index);

  @override
  List<Object> get props => [index];
}
