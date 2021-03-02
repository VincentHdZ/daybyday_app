import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../models/thing.dart';

class Things with ChangeNotifier {
  List<Thing> _items = [];
  UnmodifiableListView<Thing> get items => UnmodifiableListView(_items);
  final String _urlBase =
      "FIRE_BASE_URL";

  Future<void> fetchAndSetThings() async {
    try {
      final DateFormat dateTimeFormatter = DateFormat('yyyy-MM-dd');
      final String url = "${_urlBase}things.json";
      final http.Response response = await http.get(url);
      final Map<String, dynamic> dataThings =
          json.decode(response.body) as Map<String, dynamic>;
      if (dataThings != null) {
        dataThings.forEach((thingId, thingData) {
          _items.add(new Thing(
            id: thingId,
            label: thingData['label'],
            description: thingData['description'],
            deadline: thingData['deadline'] != null
                ? dateTimeFormatter.parse(thingData['deadline'])
                : null,
            isChecked: thingData['isChecked'] as bool,
            blocThingsId: thingData['blocThingsId'],
          ));
        });
      }
      notifyListeners();
    } catch (error) {
      print("Error -- $error");
      throw error;
    }
  }

  Thing findById(String id) {
    return _items.firstWhere((thing) => thing.id == id);
  }

  List<Thing> findByBlocThingsId(String blocThingsId) {
    return _items.where((thing) => thing.blocThingsId == blocThingsId).toList();
  }

  Future<void> addThing(Thing createdThing) async {
    try {
      final String url = "${_urlBase}things.json";
      final http.Response response = await http.post(url,
          body: json.encode({
            'label': createdThing.label,
            'description': createdThing.description,
            'deadline': createdThing.deadline != null ? createdThing.deadline.toString() : null,
            'isChecked': createdThing.isChecked,
            'blocThingsId': createdThing.blocThingsId
          }));
      final Thing addedThing = new Thing(
          id: json.decode(response.body)['name'],
          label: createdThing.label,
          description: createdThing.description,
          deadline: createdThing.deadline,
          isChecked: createdThing.isChecked,
          blocThingsId: createdThing.blocThingsId);
      _items.add(addedThing);
      notifyListeners();
    } catch (error) {
      print("Error -- $error");
      throw error;
    }
  }

  Future<void> updateThing(Thing editedThing) async {
    try {
      final String editedThingId = editedThing.id;
      final String url = "${_urlBase}things/$editedThingId.json";
      await http.patch(url,
          body: json.encode({
            'label': editedThing.label,
            'description': editedThing.description,
            'deadline': editedThing.deadline != null ? editedThing.deadline.toString() : null,
            'isChecked': editedThing.isChecked,
          }));
      final int thingIndex = _items.indexWhere((t) => t.id == editedThing.id);
      _items[thingIndex] = editedThing;
      notifyListeners();
    } catch (error) {
      print("Error -- $error");
      throw error;
    }
  }

  Future<void> toggleStateThing(String thingId, bool isChecked) async {
    try {
      final String url = "${_urlBase}things/$thingId.json";
      await http.patch(url,
          body: json.encode({
            'isChecked': isChecked,
          }));
      notifyListeners();
    } catch (error) {
      print("Error -- $error");
      throw error;
    }
  }

  Future<void> revomeThing(String thingId) async {
    try {
      final String url = "${_urlBase}things/$thingId.json";
      await http.delete(url);
      _items.removeWhere((thing) => thing.id == thingId);
      notifyListeners();
    } catch (error) {
      print("Error -- $error");
      throw error;
    }
  }
}
