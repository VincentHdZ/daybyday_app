import 'package:flutter/material.dart';

import 'thing.dart';

import '../utils/enums/status.dart';

class BlocThings with ChangeNotifier {
  final String id;
  String title;
  List<Thing> things;
  int checkedCount;
  Status state;

  BlocThings({
    this.id,
    this.title,
    this.things,
    this.checkedCount = 0,
    this.state = Status.empty,
  });
}
