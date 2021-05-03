import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

import 'package:daybyday_app/models/blocthings.dart';
import 'package:daybyday_app/models/thing.dart';

import 'package:daybyday_app/services/providers/blocsthings.dart';
import 'package:daybyday_app/services/providers/things.dart';

import 'package:daybyday_app/ui/pages/thing_details_page.dart';

import 'package:daybyday_app/utils/daybyday_resources.dart';
import 'package:daybyday_app/utils/daybyday_theme_app.dart';

class ThingCard extends StatelessWidget {
 String _getTitleSubString(String title) {
    return title.length > 10 ? title.substring(0, 10) + "..." : title;
  }

   String _getDescriptionSubString(String title) {
    return title.length > 50 ? title.substring(0, 50) + "..." : title;
  }
  
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ThingDetailsPage.routeName,
            arguments: thing.id);
      },
      child: Container(
        key: ValueKey(thing.id),
        width: double.infinity,
        height: 250,
        child: Card(
          color: DayByDayAppTheme.accentColor,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getTitleSubString(thing.label),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    thing.deadline != null
                        ? Text(
                            "${dateTimeFormatter.format(thing.deadline)}",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "_/ _/___",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                  ],
                ),
              ),
              Align(
                alignment: thing.description != null && thing.description.isNotEmpty ? Alignment.centerLeft :
                    Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(thing.description != null && thing.description.isNotEmpty ? _getDescriptionSubString(thing.description) :
                    "...",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    Ink(
                      decoration: ShapeDecoration(
                        color: null,
                        shape: CircleBorder(
                            side: BorderSide(
                          color: thing.isChecked ?  Colors.green[700] : Colors.white,
                          width: 2,
                        )),
                      ),
                      child: IconButton(
                        splashColor: thing.isChecked ? Colors.white70 : Colors.green[700],
                        highlightColor: thing.isChecked ? Colors.white70 : Colors.green[700],
                        icon: Icon(thing.isChecked ? Icons.done : Icons.done_outline_sharp),
                        color: thing.isChecked ?  Colors.green[700] : Colors.white,
                        onPressed: () {
                          _checkuncheck(context, thing, thingsList);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Ink(
                      decoration: const ShapeDecoration(
                        color: null,
                        shape: CircleBorder(
                            side: BorderSide(
                          color: Colors.white,
                          width: 2,
                        )),
                      ),
                      child: IconButton(
                        splashColor: Colors.red[700],
                        highlightColor: Colors.red[700],
                        icon: Icon(Icons.delete_outline),
                        color: Colors.white,
                        onPressed: () {
                          _remove(context, thing, thingsList);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
