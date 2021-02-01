import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/task_provider.dart';
import 'package:pomodoro_app/widgets/project_item.dart';
import './../models/project_provider.dart';
import 'package:provider/provider.dart';
import './projectFormScreen.dart';

class ProjectsScreen extends StatefulWidget {
  //bar for storting screen path
  static const route = '/projects';

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  var projects = null;
  var _isInit = true;
  var _isLoading = false;
  var projectsProvider = null;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProjectProvider>(context).fetchProjects().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
    projectsProvider = Provider.of<ProjectProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    projects = projectsProvider.projects;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Your Projects'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_rounded,
            ),
            iconSize: 32,
            color: Theme.of(context).accentColor,
            onPressed: () =>
                Navigator.of(context).pushNamed(ProjectFormScreen.route),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<ProjectProvider>(context, listen: false).fetchProjects();
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: projects.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: Image.asset(
                        'assets/images/no_tasks.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      'You don`t have any projects',
                      style: TextStyle(fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Start something big!',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                )
              : GridView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, i) => ProjectItem(
                    id: projects[i].id,
                    title: projects[i].title,
                  ),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2.3 / 2.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.of(context).pushNamed(ProjectFormScreen.route);
      //   },
      // ),
    );
  }
}
