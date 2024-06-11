import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/bloc/reminder_bloc.dart';
import 'package:reminder_app/bloc/reminder_event.dart';
import 'package:reminder_app/models/reminder.dart';

class EditReminderScreen extends StatefulWidget {
  final Reminder reminder;
  final int index;

  EditReminderScreen({required this.reminder, required this.index});

  @override
  _EditReminderScreenState createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {
  late TextEditingController _titleController;
  late TextEditingController _dateTimeController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.reminder.title);
    _dateTimeController = TextEditingController(text: DateFormat.yMd().add_jm().format(widget.reminder.dateTime));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _dateTimeController,
              decoration: InputDecoration(
                labelText: 'Date and Time',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    final dateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    _dateTimeController.text = DateFormat.yMd().add_jm().format(dateTime);
                  }
                }
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                if (_dateTimeController.text.isEmpty || title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill out all fields')),
                  );
                  return;
                }
                final dateTime = DateFormat.yMd().add_jm().parse(_dateTimeController.text);
                context.read<ReminderBloc>().add(UpdateReminder(widget.index, title, dateTime));
                Navigator.pop(context);
              },
              child: Text('Update Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
