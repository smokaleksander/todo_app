import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class TaskForm extends StatefulWidget {
  final Function addTs;

  TaskForm(this.addTs);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _titleController = TextEditingController();
  DateTime _selectedDate;

  void _addTaskFormSubmit() {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty) {
      return;
    }
    widget.addTs(enteredTitle, _selectedDate);

    Navigator.of(context).pop();
  }

  void _showTaskDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime(2050))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(hintText: 'New task'),
            controller: _titleController,
          ),
          Container(
            height: 70,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'no date specified'
                        : DateFormat.yMMMMEEEEd().format(_selectedDate),
                  ),
                ),
                FlatButton(
                  child: Text(
                    'Choose date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  textColor: Colors.blue,
                  onPressed: _showTaskDatePicker,
                )
              ],
            ),
          ),
          ElevatedButton(
            child: Text('Add Task'),
            onPressed: _addTaskFormSubmit,
          )
        ],
      ),
    );
  }
}
