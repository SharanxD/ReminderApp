
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:reminder/Settingspage.dart';
import 'package:reminder/HistoryPage.dart';
import 'package:reminder/functionspage.dart';

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
      case 2:
        page = Settings();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.black,
          title:
          const Text('Welcome -namehere-',
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 21)),

        ),
        bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
          currentIndex: selectedIndex,
          onTap: (value){
          setState(() {
            selectedIndex=value;
          });
          },

        ),
        body:

        Container(
          color: Theme.of(context).colorScheme.primary,
          child: page,
        ),

      );
    });
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


