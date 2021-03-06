import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/project.dart';
import 'package:pomodoro_app/models/project_provider.dart';

import 'package:provider/provider.dart';
import 'package:pomodoro_app/models/task_provider.dart';
import './../models/project.dart';
import './../models/task_provider.dart';

class ProjectFormScreen extends StatefulWidget {
  static const route = '/project-form';
  @override
  _ProjectFormScreenState createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  String _titleInitialValue;
  final _form = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  var _editedProject = Project(id: null, title: null);
  //var for loading task when in editing mode
  var _isInit = true;
  var _isLoading = false;
  //check if argument passed in route wchich means editting mode
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final projectId = ModalRoute.of(context).settings.arguments as String;
      if (projectId != null) {
        _editedProject = Provider.of<ProjectProvider>(context, listen: false)
            .findById(projectId);
        _titleInitialValue = _editedProject.title;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _projectFormSubmit() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProject.id != null) {
      Provider.of<ProjectProvider>(context, listen: false)
          .updateProject(_editedProject.id, _editedProject)
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
      Provider.of<ProjectProvider>(context, listen: false)
          .addProject(_editedProject)
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

  Future<void> _deleteProjectWithTasks(String id) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<TaskProvider>(context, listen: false)
        .deleteTasksWithProjectId(id)
        .catchError((error) {
      setState(() {
        _isLoading = false;
      });
      return;
    });
    Provider.of<ProjectProvider>(context, listen: false)
        .deleteProject(id)
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
    });
  }

  Future<void> _deleteProjectWithoutTasks(String id) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<TaskProvider>(context, listen: false)
        .setTasksProjectIdToNull(id)
        .catchError((error) {
      return;
    });
    Provider.of<ProjectProvider>(context, listen: false)
        .deleteProject(id)
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
    });
  }

  Future<bool> _deleteDialog(BuildContext context, String projectId) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Delete all tasks in project?'),
              content: Text(
                  'Do you want to delete all tasks in project? If no, tasks will still with exists with no project assigned'),
              actions: <Widget>[
                FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      _deleteProjectWithoutTasks(projectId).then((_) {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.of(ctx).pop();
                        Navigator.of(ctx).pop();
                        Navigator.of(ctx).pop();
                      });
                    }),
                FlatButton(
                  child: Text('yes'),
                  onPressed: () {
                    _deleteProjectWithTasks(projectId).then((_) {
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.of(ctx).pop();
                      Navigator.of(ctx).pop();
                      Navigator.of(ctx).pop();
                    });
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              title: Text(_editedProject.id == null
                  ? 'Create new Project'
                  : 'Edit Project'),
              actions: [
                if (_editedProject.id != null)
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteDialog(context, _editedProject.id),
                  )
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                child: Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          initialValue: _titleInitialValue,
                          focusNode: _titleFocusNode,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              hintText: 'Every project need a name',
                              labelText: 'Project name',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor)),
                          onSaved: (value) {
                            _editedProject = Project(
                              id: _editedProject.id,
                              title: value,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Task title can`t be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25)),
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColor,
                          child: Text(_editedProject.id == null
                              ? 'Create new Project'
                              : 'Edit Project'),
                          onPressed: _projectFormSubmit,
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
