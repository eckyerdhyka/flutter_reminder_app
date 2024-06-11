import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/bloc/reminder_bloc.dart';
import 'package:reminder_app/bloc/reminder_event.dart';
import 'package:reminder_app/bloc/reminder_state.dart';
import 'package:reminder_app/models/reminder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reminder_app/screens/edit_reminder_screen.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputFields(context),
            SizedBox(height: 20),
            _buildReminderList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields(BuildContext context) {
  return Column(
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
        onPressed: () async {
          final title = _titleController.text;
          if (_dateTimeController.text.isEmpty || title.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please fill out all fields')),
            );
            return;
          }
          
          // Request notification permission
          var status = await Permission.notification.status;
          if (status.isDenied || status.isPermanentlyDenied) {
            status = await Permission.notification.request();
            if (status.isPermanentlyDenied) {
              // Permission is permanently denied, prompt user to open app settings
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Notification Permission Required'),
                  content: Text('Please enable notification permissions in your device settings to use this app.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await openAppSettings(); // Open app settings
                      },
                      child: Text('Open Settings'),
                    ),
                  ],
                ),
              );
              return; // Exit the function
            }
          }
          
          // Proceed with adding the reminder
          final dateTime = DateFormat.yMd().add_jm().parse(_dateTimeController.text);
          context.read<ReminderBloc>().add(AddReminder(title, dateTime));
          _titleController.clear();
          _dateTimeController.clear();
        },
        child: Text('Add Reminder'),
      ),
    ],
  );
}


  Widget _buildReminderList() {
    return BlocBuilder<ReminderBloc, ReminderState>(
      builder: (context, state) {
        if (state is ReminderLoaded) {
          return Expanded(
            child: ListView.builder(
              itemCount: state.reminders.length,
              itemBuilder: (context, index) {
                final reminder = state.reminders[index];
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(reminder.title),
                    subtitle: Text(DateFormat.yMd().add_jm().format(reminder.dateTime)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditReminderScreen(reminder: reminder, index: index),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            context.read<ReminderBloc>().add(RemoveReminder(index));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

