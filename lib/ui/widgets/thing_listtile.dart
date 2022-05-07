import 'package:daybyday_app/services/providers/blocsthings.dart';

import '../../models/blocthings.dart';
import 'package:daybyday_app/services/providers/things.dart';
import 'package:daybyday_app/ui/pages/thing_details_page.dart';
import 'package:daybyday_app/utils/daybyday_resources.dart';
import 'package:daybyday_app/utils/daybyday_theme_app.dart';
import 'package:intl/intl.dart';

import 'package:daybyday_app/models/thing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThingListTile extends StatelessWidget {
  void _checkuncheck(BuildContext ctx, Thing thing, BlocThings thingsList) {
    thing.toggleState();
    Provider.of<Things>(ctx, listen: false)
        .toggleStateThing(thing.id, thing.isChecked)
        .then((value) => Provider.of<BlocsThings>(ctx, listen: false)
            .updateBlocThingsCheckedCount(thingsList.id));
  }

  Future<void> _remove(
      BuildContext context, Thing thing, BlocThings blocThings) async {
    final response = await _showAlertDialog(context, thing);

    if (response == 'yes') {
      Provider.of<Things>(context, listen: false)
          .revomeThing(thing.id)
          .then((_) => {
                Provider.of<BlocsThings>(context, listen: false)
                    .removeThingFromBlocThings(blocThings.id, thing.id)
              })
          .then((value) => {
                Provider.of<BlocsThings>(context, listen: false)
                    .updateBlocThingsCheckedCount(blocThings.id)
              });
    }
  }

  Future<String> _showAlertDialog(
      BuildContext context, Thing selectedThing) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(
              DayByDayRessources.textRessourceConfirmDeleteThingTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Text(
                "Vous confirmez la suppression de \"${selectedThing.label}\" ?",
                style: TextStyle(fontSize: 14),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'yes');
                },
                child: Text(
                  DayByDayRessources.textRessourceYes,
                  style: TextStyle(
                    color: DayByDayAppTheme.accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'no');
                },
                child: Text(
                  DayByDayRessources.textRessourceNo,
                  style: TextStyle(
                    color: DayByDayAppTheme.accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final thing = Provider.of<Thing>(context);
    final thingsList =
        Provider.of<BlocsThings>(context).findById(thing.blocThingsId);
    final DateFormat dateTimeFormatter = DateFormat('dd/MM/yyyy');

    return Container(
        key: ValueKey(thing.id),
        width: double.infinity,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ThingDetailsPage.routeName,
                    arguments: thing.id);
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: DayByDayAppTheme.accentColor,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        thing.deadline != null
                            ? Text(
                                "${dateTimeFormatter.format(thing.deadline)}",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              )
                            : Text(
                                "_/ _/___",
                              ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${thing.label}",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -10,
              left: -10,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: DayByDayAppTheme.accentColor,
                ),
                child: IconButton(
                  padding: EdgeInsets.all(4),
                  icon: thing.isChecked
                      ? Icon(
                          Icons.restore,
                          size: 20,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.black,
                        ),
                  onPressed: () {
                    _checkuncheck(context, thing, thingsList);
                  },
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              right: -10,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: DayByDayAppTheme.accentColor,
                ),
                child: IconButton(
                  padding: EdgeInsets.all(4),
                  icon: Icon(
                    Icons.delete,
                    size: 20,
                    color: Colors.redAccent[700],
                  ),
                  onPressed: () {
                    _remove(context, thing, thingsList);
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
