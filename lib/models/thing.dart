import 'package:flutter/material.dart';

class Thing with ChangeNotifier {
  final String id;
  final String label;
  final String description;
  DateTime deadline;
  bool isChecked;
  final String blocThingsId;

  Thing({
    this.id,
    this.label,
    this.description,
    this.deadline,
    this.isChecked = false,
    this.blocThingsId,
  });

  void toggleState() {
    isChecked = !isChecked;

    notifyListeners();
  }
}
