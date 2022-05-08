import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../models/blocthings.dart';
import '../../models/thing.dart';

import '../../utils/enums/status.dart';

class BlocsThings with ChangeNotifier {
  List<BlocThings> _items = [];
  // UnmodifiableListView<BlocThings> get items => UnmodifiableListView(_items);
  List<BlocThings> get items {
    return _items;
  }

  final String _urlBase = dotenv.env['END_POINT'];
  final String authToken;
  final String userId;

  BlocsThings(this.authToken, this.userId, this._items);

  BlocThings findById(String id) {
    return _items.firstWhere((blocThings) => blocThings.id == id);
  }

  Future<void> fetchAndSetBlocsThings() async {
    try {
      final String url =
          '${_urlBase}blocsthings.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
      final http.Response response = await http.get(url);
      final Map<String, dynamic> dataBlocsThings =
          json.decode(response.body) as Map<String, dynamic>;
      final List<BlocThings> loadedBlocsThings = [];
      if (dataBlocsThings != null) {
        dataBlocsThings.forEach((blocThingsId, blocThingsData) {
          loadedBlocsThings.add(new BlocThings(
            id: blocThingsId,
            title: blocThingsData['title'],
            checkedCount: blocThingsData['checkedCount'],
            state: Status.values.firstWhere((element) =>
                element.toString().split('.')[1] == blocThingsData['state']),
            things: [],
          ));
        });
        _items = loadedBlocsThings;
        notifyListeners();
      }
    } catch (error) {
      print("Error -- $error");
      throw error;
    }
  }

  Future<void> addBlocThings(BlocThings createdBlocThings) async {
    try {
      final String url = "${_urlBase}blocsthings.json?auth=$authToken";
      final http.Response response = await http.post(
        url,
        body: json.encode({
          'title': createdBlocThings.title,
          'state': createdBlocThings.state.toString().split('.')[1],
          'checkedCount': createdBlocThings.checkedCount,
          'things': createdBlocThings.things,
          'creatorId': userId,
        }),
      );
      final BlocThings addedBlocThings = new BlocThings(
        id: json.decode(response.body)['name'],
        title: createdBlocThings.title,
        state: Status.values
            .firstWhere((element) => element == createdBlocThings.state),
        checkedCount: createdBlocThings.checkedCount,
        things: [],
      );
      _items.add(addedBlocThings);
      notifyListeners();
    } catch (error) {
      print("Error -- $error");
      throw error;
    }
  }

  Future<void> updateBlocThings(BlocThings editedBlocThings) async {
    try {
      final String id = editedBlocThings.id;
      final String url = "${_urlBase}blocsthings/$id.json?auth=$authToken";
      await http.patch(url,
          body: json.encode({'title': editedBlocThings.title}));
      final int thingsIndex =
          _items.indexWhere((element) => element.id == editedBlocThings.id);
      _items[thingsIndex] = editedBlocThings;
      notifyListeners();
    } catch (error) {
      print("Error -- $error");
      throw error;
    }
  }

  Future<void> deleteBlocThings(String blocThingsId) async {
    try {
      final String url =
          "${_urlBase}blocsthings/$blocThingsId.json?auth=$authToken";
      await http.delete(url);
      final int thingsToRemoveIndex =
          _items.indexWhere((element) => element.id == blocThingsId);
      _items[thingsToRemoveIndex].things.clear();
      _items.removeWhere((thingsList) => thingsList.id == blocThingsId);
      notifyListeners();
    } catch (error) {
      print("Error -- $error");
      throw error;
    }
  }

  Future<void> addThingToBlocThings(
      String blocThingsId, Thing createdThing) async {
    try {
      String url =
          "${_urlBase}blocsthings/$blocThingsId/things.json?auth=$authToken";
      if (blocThingsId.isNotEmpty) {
        await http.post(url,
            body: json
                .encode({'id': createdThing.id, 'label': createdThing.label}));
      }
      final blocThingsIndex =
          _items.indexWhere((element) => element.id == blocThingsId);
      _items[blocThingsIndex].things.add(createdThing);
      notifyListeners();
    } catch (error) {
      print("Error -- $error");
      throw error;
    }
  }

  Future<void> updateBlocThingsCheckedCount(String blocThingsId) async {
    try {
      String url = "${_urlBase}blocsthings/$blocThingsId.json?auth=$authToken";
      final thingsIndex =
          _items.indexWhere((element) => element.id == blocThingsId);
      final int checkedCount = _items[thingsIndex]
          .things
          .where((element) => element.isChecked == true)
          .toList()
          .length;
      await http.patch(url,
          body: json.encode({
            'checkedCount': checkedCount,
          }));

      _items[thingsIndex].checkedCount = checkedCount;
      notifyListeners();
    } catch (error) {
      print("Error -- $error");
      throw error;
    }
  }

  Future<void> removeThingFromBlocThings(
      String blocThingsId, String thingId) async {
    try {
      final int blocThingsIndex =
          _items.indexWhere((element) => element.id == blocThingsId);
      final String url =
          "${_urlBase}blocsthings/$blocThingsId/things/$thingId.json?auth=$authToken";
      await http.delete(url);
      _items[blocThingsIndex]
          .things
          .removeWhere((element) => element.id == thingId);
      notifyListeners();
    } catch (error) {
      print("Error -- $error");
      throw error;
    }
  }
}
