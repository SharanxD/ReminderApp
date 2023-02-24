import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Task {
  final int id;
  final String taskname;
  const Task({
    required this.id,
    required this.taskname,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Reminder',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blue,
          useMaterial3: true,
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<String> tasks = [];
  List<String> dates = [];
  List<String> taskcompleted = [];
  List<String> datescompleted = [];

  void taskadd(var abc, var def) {
    tasks.add(abc);
    print(def);
    dates.add(def);
    notifyListeners();
  }

  void taskcomplete(var comp, var a) {
    taskcompleted.add(comp);
    datescompleted
        .add(DateFormat("dd-MM-yyyy").format(DateTime.now()).toString());
    tasks.remove(comp);
    dates.removeAt(a);
    notifyListeners();
  }

  void taskremove(var xyz) {
    taskcompleted.removeAt(xyz);
    datescompleted.removeAt(xyz);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = DataPage();
        break;
      case 1:
        page = CompletedPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 650,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.check_circle),
                    label: Text('History!'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class CompletedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('HISTORY',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        body: ListView(
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                      'You have completed ${appState.taskcompleted.length} Tasks:')),
            ),
            SizedBox(height: 30),
            for (var i = 0; i < appState.taskcompleted.length; i++)
              Card(
                  child: ListTile(
                title: Text(appState.taskcompleted[i]),
                subtitle: Text("Completed on: ${appState.datescompleted[i]}"),
                trailing: ElevatedButton(
                    onPressed: () {
                      appState.taskremove(i);
                      const snackBar = SnackBar(
                        content: Text("Task deleted!"),
                        duration: Duration(milliseconds: 1500),
                        behavior: SnackBarBehavior.floating,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Icon(Icons.delete)),
              ))
          ],
        ));
  }
}

class DataPage extends StatefulWidget {
  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final myController = TextEditingController();
  final dateController = TextEditingController();
  // ignore: non_constant_identifier_names
  Future<void> _InputTask(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          var app = context.watch<MyAppState>();
          return AlertDialog(
              title: Text(
                'Enter a new Task',
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                // wrap content in flutter
                children: <Widget>[
                  TextField(
                    controller: myController,
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                        labelText: "Choose the Deadline",
                        suffixIcon: Icon(Icons.calendar_today)),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await (showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100)));
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat("dd-MM-yyyy").format(pickedDate);
                        setState(() {
                          dateController.text = formattedDate.toString();
                        });
                      } else {}
                    },
                  )
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      if (myController.text.isEmpty) {
                        const snackBar = SnackBar(
                          content: Text('Enter a valid Task!'),
                          duration: Duration(milliseconds: 1500),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        if (app.tasks.contains(myController.text)) {
                          const snackBar = SnackBar(
                            content: Text('Error: Task already Exists!'),
                            duration: Duration(milliseconds: 1500),
                            behavior: SnackBarBehavior.floating,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          app.taskadd(myController.text, dateController.text);
                          myController.clear();
                          dateController.clear();
                          const snackBar = SnackBar(
                            content: Text('Task Added Successfully!'),
                            duration: Duration(milliseconds: 1500),
                            behavior: SnackBarBehavior.floating,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        setState(() {
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: Text('ADD')),
                ElevatedButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('TASK VIEW',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            _InputTask(context);
          },
          child: const Icon(Icons.add, color: Colors.black),
        ),
        body: ListView(
          children: [
            SizedBox(height: 30),
            Center(child: Text("You have ${appState.tasks.length} Tasks Left")),
            SizedBox(height: 30),
            //appState.fetch();
            for (var i = 0; i < appState.tasks.length; i++)
              Card(
                  child: Column(children: <Widget>[
                ListTile(
                  title: Text(appState.tasks[i]),
                  subtitle: Text("Due Date: ${appState.dates[i]}"),
                  trailing: ElevatedButton(
                      onPressed: () {
                        appState.taskcomplete(appState.tasks[i], i);
                        const snackBar = SnackBar(
                          content: Text("Task Completed!!"),
                          duration: Duration(milliseconds: 1500),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Icon(
                        Icons.check_circle_outline,
                      )),
                )
              ]))
          ],
        ));
  }
}
