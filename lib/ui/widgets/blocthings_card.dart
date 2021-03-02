import 'package:daybyday_app/services/providers/things.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/blocthings_details_page.dart';

import '../../models/blocthings.dart';

import '../../services/providers/blocsthings.dart';

import '../../utils/daybyday_resources.dart';
import '../../utils/daybyday_theme_app.dart';

class BlocThingsCard extends StatefulWidget {
  final Function handleFunc;

  BlocThingsCard(this.handleFunc);

  @override
  _BlocThingsCardState createState() => _BlocThingsCardState();
}

class _BlocThingsCardState extends State<BlocThingsCard> {
  @override
  Widget build(BuildContext context) {
    final blocThings = Provider.of<BlocThings>(context);
    blocThings.things = Provider.of<Things>(context).findByBlocThingsId(blocThings.id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, BlocThingsDetailsPage.routeName,
            arguments: blocThings.id);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              stops: [0.1, 0.3, 0.9, 1],
              colors: [
                DayByDayAppTheme.accentColor,
                DayByDayAppTheme.accentColor,
                DayByDayAppTheme.accentColor,
                DayByDayAppTheme.accentColor,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                blocThings.title.length >= 16
                    ? _getTitleSubString(blocThings.title)
                    : blocThings.title,
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              Stack(
                fit: StackFit.loose,
                overflow: Overflow.visible,
                children: [
                  Container(
                    height: 95,
                    width: 95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(55),
                      color: Colors.black26,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: _changeBlocThingsTextState(blocThings),
                        ),
                        Text(
                          "/",
                          style: TextStyle(
                            fontFamily: DayByDayAppTheme
                                .fontFamilyBigShouldersStencilText,
                            fontSize: 25,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                              blocThings.things.length == 0
                                  ? "_"
                                  : blocThings.things.length.toString(),
                              style: TextStyle(
                                fontFamily: DayByDayAppTheme
                                    .fontFamilyBigShouldersStencilText,
                                fontSize: 20,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: -25,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: _changeBlocThingsIconState(blocThings),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.edit,
                      ),
                      splashColor: Colors.red,
                      iconSize: 28,
                      onPressed: () {
                        widget.handleFunc(context, blocThings);
                      }),
                  IconButton(
                      icon: Icon(Icons.delete),
                      iconSize: 28,
                      onPressed: () async {
                        final response =
                            await _showAlertDialog(context, blocThings);
                        if (response == 'yes') {
                          Provider.of<BlocsThings>(context, listen: false)
                              .deleteBlocThings(blocThings.id);
                        }
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _changeBlocThingsTextState(BlocThings blocThings) {
    if (blocThings.things.length > 0) {
      return Text(
        blocThings.checkedCount.toString(),
        // thingsList.checkedThingsCount.toString(),
        style: TextStyle(
          fontFamily: DayByDayAppTheme.fontFamilyBigShouldersStencilText,
          fontSize: 20,
        ),
      );
    } else {
      return Text(
        blocThings.things.length == 0
            ? "_"
            : blocThings.checkedCount.toString(),
        // : thingsList.checkedThingsCount.toString(),
        style: TextStyle(
          fontFamily: DayByDayAppTheme.fontFamilyBigShouldersStencilText,
          fontSize: 20,
        ),
      );
    }
  }

  Widget _changeBlocThingsIconState(BlocThings blocThings) {
    if (blocThings.things.length == 0) {
      return Icon(
        DayByDayRessources.iconRessourceStatusEmpty,
        size: 25,
      );
    } else if (blocThings.things.length == blocThings.checkedCount) {
      return Icon(
        DayByDayRessources.iconRessourceStatusDone,
        size: 25,
      );
    } else {
      return Icon(
        DayByDayRessources.iconRessourceStatusInProgress,
        size: 25,
      );
    }
  }

  String _getTitleSubString(String title) {
    return title.substring(0, 14) + "...";
  }

  Future<String> _showAlertDialog(
      BuildContext context, BlocThings blocThings) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(
              DayByDayRessources.textRessourceConfirmDeleteThingsListTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Text(
                "Vous confirmez la suppression de \"${blocThings.title}\" ?",
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
}
