import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:reminder/functionspage.dart';

class Settings extends StatefulWidget{
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body:

      Image.asset('assets/tasks.jpg'),

    );
    throw UnimplementedError();
  }
}