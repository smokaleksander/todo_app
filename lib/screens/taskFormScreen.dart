import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/pomodoroProvider.dart';
import 'package:pomodoro_app/models/project.dart';
import 'package:pomodoro_app/models/project_provider.dart';
import './../widgets/date_dialog.dart';
import './../widgets/project_dialog.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/models/task_provider.dart';
import './../models/task.dart';
import './../models/task_provider.dart';
import 'package:intl/intl.dart';
import 'package:duration/duration.dart';

class TaskFormScreen extends StatefulWidget {
  static const route = '/task-form';
  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  //bool for auto setting project if adding inside project
  bool _isProjectScoped = false;
  //
  String _titleInitialValue;
  final _dateFieldController = TextEditingController()..text = 'No duedate';
  final _projectFieldController = TextEditingController()..text = 'No project';
  final _form = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  var _choosenProject = Project(id: null, title: null);
  var _editedTask = Task(
      id: null,
      title: '',
      date: null,
      isDone: false,
      projectId: null,
      doneDate: null);
  int _pomodoroNumber = 0;
  int _allPomodoroDuration = 0;
  //var for loading task when in editing mode
  var _isInit = true;
  var _isLoading = false;

  //check if argument passed in route wchich means editting mode
  @override
  void didChangeDependencies() {
    if (_isInit) {
      //get arguments from navigator object
      final args = ModalRoute.of(context).settings.arguments as Map;
      final taskId = args['taskId'];
      final projectId = args['projectId'];
      //check if task id was passed, if so ->edit mode and fetch object
      if (taskId != null) {
        _editedTask =
            Provider.of<TaskProvider>(context, listen: false).findById(taskId);
        _titleInitialValue = _editedTask.title;
        //get pomodor numbers for task
        final stats = Provider.of<PomodoroProvider>(context, listen: false)
            .getStatsForTask(taskId);
        _pomodoroNumber = stats['pomoNum'];
        _allPomodoroDuration = stats['length'];

        //set date if passed
        if (_editedTask.date != null) {
          _dateFieldController.text =
              DateFormat('dd/MM/yyyy').format(_editedTask.date).toString();
        }
        //get project details fot task if project id passed
        if (_editedTask.projectId != null) {
          _projectFieldController.text =
              Provider.of<ProjectProvider>(context, listen: false)
                  .findById(_editedTask.projectId)
                  .title;
        }
      }
      //if project ID passed through navigator-> adding/editting task in specific project
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

  Future<void> _taskFormSubmit() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    print(_editedTask.projectId);
    //if task id is set we are in edit mode -> update
    if (_editedTask.id != null) {
      Provider.of<TaskProvider>(context, listen: false)
          .updateTask(_editedTask.id, _editedTask)
          .catchError((error) {
        return showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                    title: Text("Something went wrong!"),
                    content: Text(error.toString()),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ]));
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } else {
      Provider.of<TaskProvider>(context, listen: false)
          .addTask(_editedTask)
          .catchError((error) {
        return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Something went wrong!"),
            content: Text(error.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
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

  Future<bool> _deleteDialog(
    BuildContext context,
    String taskId,
  ) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to delete this task?'),
              actions: <Widget>[
                FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    }),
                FlatButton(
                  child: Text('yes'),
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    Navigator.of(ctx).pop();
                    Provider.of<TaskProvider>(context, listen: false)
                        .deleteTask(taskId)
                        .catchError((error) {});
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title:
            Text(_editedTask.id == null ? 'Create new task' : 'Task details'),
        actions: <Widget>[
          if (_editedTask.id != null)
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              onPressed: () => _deleteDialog(context, _editedTask.id),
            )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor)),
                          onSaved: (value) {
                            _editedTask = Task(
                                id: _editedTask.id,
                                title: value,
                                projectId: _editedTask.projectId,
                                date: _editedTask.date,
                                isDone: _editedTask.isDone,
                                doneDate: _editedTask.doneDate);
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
                                labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor)),
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
                                    isDone: _editedTask.isDone,
                                    doneDate: _editedTask.doneDate);
                              } else {
                                _editedTask = Task(
                                    id: _editedTask.id,
                                    title: _editedTask.title,
                                    projectId: _editedTask.projectId,
                                    date: DateFormat('dd/MM/yyyy').parse(value),
                                    isDone: _editedTask.isDone,
                                    doneDate: _editedTask.doneDate);
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
                                  //_projectFieldController.text = onValue.title;
                                  if (onValue.id == null) {
                                    _projectFieldController.text = 'No project';
                                    _choosenProject =
                                        Project(id: null, title: null);
                                  } else {
                                    _projectFieldController.text =
                                        onValue.title;
                                    _choosenProject = Project(
                                        id: onValue.id, title: onValue.title);
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
                                labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor)),
                            onSaved: (value) {
                              if (value != 'No project') {
                                _editedTask = Task(
                                    id: _editedTask.id,
                                    title: _editedTask.title,
                                    projectId: _choosenProject.id,
                                    date: _editedTask.date,
                                    isDone: _editedTask.isDone,
                                    doneDate: _editedTask.doneDate);
                              } else {
                                _editedTask = Task(
                                    id: _editedTask.id,
                                    title: _editedTask.title,
                                    projectId: null,
                                    date: _editedTask.date,
                                    isDone: _editedTask.isDone,
                                    doneDate: _editedTask.doneDate);
                              }
                            },
                          ),
                        ),
                      ),
                      if (_editedTask.id != null)
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Icon(
                                      Icons.timer_rounded,
                                    ),
                                  ),
                                  Text(
                                    'Pomodoro numbers',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        _pomodoroNumber.toString(),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Icon(
                                        Icons.timer_rounded,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                  if (_pomodoroNumber != 0)
                                    Text(_allPomodoroDuration.toString() + 'm')
                                ],
                              ),
                            ),
                          ],
                        )),
                      Container(
                        margin: EdgeInsets.only(top: 25, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25)),
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            _editedTask.id == null
                                ? 'Create task'
                                : 'Save task',
                          ),
                          onPressed: _taskFormSubmit,
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
