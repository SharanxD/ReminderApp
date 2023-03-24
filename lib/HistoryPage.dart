
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:reminder/functionspage.dart';



class CompletedPage extends StatefulWidget {


  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {

  Future<void> Deletemess(BuildContext context,var i) async{
    return showDialog(
        context: context,
        builder: (context) {
          var app = context.watch<MyAppState>();
          return AlertDialog(
              title: Text(
                'Delete',
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                // wrap content in flutter
                children: <Widget>[
                  Text(
                    'Are you sure you want to delete the task?',
                  ),
              ]),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {

                      app.taskremove(i);
                      const snackBar = SnackBar(
                        content: Text("Task deleted!"),
                        duration: Duration(milliseconds: 1500),
                        behavior: SnackBarBehavior.floating,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text('Yes')),
                ElevatedButton(
                  child: Text('No'),
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
                          Deletemess(context,i);

                        },
                        child: Icon(Icons.delete)),
                  ))
          ],
        ));
  }
}