import 'package:equatable/equatable.dart';

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

class RemoveReminder extends ReminderEvent {
  final int index;

  const RemoveReminder(this.index);

  @override
  List<Object> get props => [index];
}
