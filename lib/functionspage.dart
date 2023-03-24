
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyAppState extends ChangeNotifier {

  List<String> tasks = [];
  List<String> dates = [];
  List<String> taskcompleted = [];
  List<String> datescompleted = [];
  List<String> Name=[];

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