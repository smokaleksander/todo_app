import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(title: const Text('Assign duedate'), children: <Widget>[
      SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context,
              DateFormat('dd/MM/yyyy').format(DateTime.now()).toString());
        },
        child: const Text('Today'),
      ),
      SimpleDialogOption(
        onPressed: () {
          Navigator.pop(
              context,
              DateFormat('dd/MM/yyyy')
                  .format(DateTime.now().add(Duration(days: 1)))
                  .toString());
        },
        child: const Text('Tomorrow'),
      ),
      SimpleDialogOption(
        onPressed: () {
          showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2019),
                  lastDate: DateTime(2030))
              .then((pickedDate) {
            if (pickedDate == null) {
              return;
            }
            Navigator.pop(context,
                DateFormat('dd/MM/yyyy').format(pickedDate).toString());
          });
        },
        child: const Text('choose date in calendar'),
      ),
      SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context, null);
        },
        child: const Text('No duedate'),
      ),
    ]);
  }
}
