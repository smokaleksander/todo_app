import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/project.dart';
import './../widgets/date_dialog.dart';
import './../widgets/project_dialog.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/models/task_provider.dart';
import './../models/task.dart';
import './../models/task_provider.dart';
import 'package:intl/intl.dart';

class TaskFormScreen extends StatefulWidget {
  static const route = '/task-form';
  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _dateFieldController = TextEditingController()..text = 'No duedate';
  final _projectFieldController = TextEditingController()..text = 'No project';
  final _form = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  var _choosenProject = Project(id: null, title: null);
  var _editedTask =
      Task(id: null, title: '', date: null, isDone: false, projectId: null);

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _dateFieldController.dispose();
    _projectFieldController.dispose();
    super.dispose();
  }

  void _taskFormSubmit() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    Provider.of<TaskProvider>(context, listen: false).addTask(_editedTask);
    Navigator.of(context).pop();
  }

  Future<String> _chooseDate(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return DateDialog();
        });
  }

  Future<Project> _chooseProject(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ProjectDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.taskId != null) {
    //   _editedTask = Provider.of<TaskProvider>(context, listen: false)
    //       .findById(widget.taskId);
    // }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                Container(
                  child: TextFormField(
                    initialValue: _editedTask.title,
                    focusNode: _titleFocusNode,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintText: 'What need to be done?',
                        labelText: 'Description',
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor)),
                    onSaved: (value) {
                      _editedTask = Task(
                          id: null,
                          title: value,
                          projectId: _editedTask.projectId,
                          date: _editedTask.date,
                          isDone: _editedTask.isDone);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Task title can`t be empty';
                      }
                      return null;
                    },
                  ),
                ),
                InkWell(
                  onTap: () => _chooseDate(context).then((onValue) {
                    setState(() {
                      _dateFieldController.text = onValue;
                    });
                  }),
                  child: Container(
                    margin: EdgeInsets.only(top: 8, bottom: 4),
                    child: TextFormField(
                      controller: _dateFieldController,
                      enabled: false,
                      decoration: InputDecoration(
                          labelText: 'Duedate',
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor)),
                      keyboardType: TextInputType.datetime,
                      onSaved: (value) {
                        print(value);
                        if (value.contains('No duedate') ||
                            value == null ||
                            value.isEmpty) {
                          print('no date');
                          _editedTask = Task(
                              id: null,
                              title: _editedTask.title,
                              projectId: _editedTask.projectId,
                              date: null,
                              isDone: _editedTask.isDone);
                        } else {
                          print('date');
                          _editedTask = Task(
                              id: null,
                              title: _editedTask.title,
                              projectId: _editedTask.projectId,
                              date: DateFormat('dd/MM/yyyy').parse(value),
                              isDone: _editedTask.isDone);
                        }
                      },
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _chooseProject(context).then((onValue) {
                    setState(() {
                      _projectFieldController.text = onValue.title;
                      if (onValue.id != null) {
                        _choosenProject =
                            Project(id: onValue.id, title: onValue.title);
                      }
                    });
                  }),
                  child: Container(
                    margin: EdgeInsets.only(top: 4, bottom: 16),
                    width: double.infinity,
                    child: TextFormField(
                      controller: _projectFieldController,
                      enabled: false,
                      decoration: InputDecoration(
                          hintText: 'No project',
                          labelText: 'Project',
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor)),
                      onSaved: (value) {
                        if (value != 'No project') {
                          _editedTask = Task(
                              id: null,
                              title: _editedTask.title,
                              projectId: _choosenProject.id,
                              date: _editedTask.date,
                              isDone: _editedTask.isDone);
                        }
                      },
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Create task',
                      ),
                      onPressed: _taskFormSubmit,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
