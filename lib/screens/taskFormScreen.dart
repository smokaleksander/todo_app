import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/project.dart';
import 'package:pomodoro_app/models/project_provider.dart';
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
  bool _isProjectScoped = false;
  String _titleInitialValue;
  final _dateFieldController = TextEditingController()..text = 'No duedate';
  final _projectFieldController = TextEditingController()..text = 'No project';
  final _form = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  var _choosenProject = Project(id: null, title: null);
  var _editedTask =
      Task(id: null, title: '', date: null, isDone: false, projectId: null);
  //var for loading task when in editing mode
  var _isInit = true;
  //check if argument passed in route wchich means editting mode
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context).settings.arguments as Map;
      final taskId = args['taskId'];
      final projectId = args['projectId'];
      if (taskId != null) {
        _editedTask =
            Provider.of<TaskProvider>(context, listen: false).findById(taskId);
        _titleInitialValue = _editedTask.title;
        if (_editedTask.date != null) {
          _dateFieldController.text =
              DateFormat('dd/MM/yyyy').format(_editedTask.date).toString();
        }
        if (_editedTask.projectId != null) {
          _projectFieldController.text =
              Provider.of<ProjectProvider>(context, listen: false)
                  .findById(_editedTask.projectId)
                  .title;
        }
      }
      if (projectId != null) {
        _choosenProject = Provider.of<ProjectProvider>(context, listen: false)
            .findById(projectId);
        _projectFieldController.text = _choosenProject.title;
        _isProjectScoped = true;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
    if (_editedTask.id != null) {
      Provider.of<TaskProvider>(context, listen: false)
          .updateTask(_editedTask.id, _editedTask);
    } else {
      Provider.of<TaskProvider>(context, listen: false).addTask(_editedTask);
    }

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title:
              Text(_editedTask.id == null ? 'Create new task' : 'Edit Task')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                Container(
                  child: TextFormField(
                    initialValue: _titleInitialValue,
                    focusNode: _titleFocusNode,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintText: 'What need to be done?',
                        labelText: 'Description',
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor)),
                    onSaved: (value) {
                      _editedTask = Task(
                          id: _editedTask.id,
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
                      if (onValue == null) {
                        _dateFieldController.text = 'No duedate';
                      } else {
                        _dateFieldController.text = onValue;
                      }
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
                        if (value.contains('No duedate') ||
                            value == null ||
                            value.isEmpty) {
                          _editedTask = Task(
                              id: _editedTask.id,
                              title: _editedTask.title,
                              projectId: _editedTask.projectId,
                              date: null,
                              isDone: _editedTask.isDone);
                        } else {
                          _editedTask = Task(
                              id: _editedTask.id,
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
                  onTap: () => {
                    if (!_isProjectScoped)
                      {
                        _chooseProject(context).then((onValue) {
                          setState(() {
                            _projectFieldController.text = onValue.title;
                            if (onValue.id == null) {
                              _projectFieldController.text = 'No project';
                              _choosenProject = Project(id: null, title: null);
                            } else {
                              _projectFieldController.text = onValue.title;
                              _choosenProject =
                                  Project(id: onValue.id, title: onValue.title);
                            }
                          });
                        })
                      }
                    else
                      {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(_projectFieldController.text),
                            content: Text(
                                'You can`t assign task to different project'),
                            actions: [
                              FlatButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                        )
                      }
                  },
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
                              id: _editedTask.id,
                              title: _editedTask.title,
                              projectId: _choosenProject.id,
                              date: _editedTask.date,
                              isDone: _editedTask.isDone);
                        } else {
                          _editedTask = Task(
                              id: _editedTask.id,
                              title: _editedTask.title,
                              projectId: null,
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
                        _editedTask.id == null ? 'Create task' : 'Save task',
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
