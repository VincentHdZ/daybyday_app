import 'package:flutter/material.dart';

import '../../models/blocthings.dart';

import '../../utils/daybyday_resources.dart';
import '../../utils/daybyday_theme_app.dart';

class BlocThingsCounter extends StatelessWidget {
  final BlocThings blocThings;

  BlocThingsCounter(this.blocThings);

  Widget _changeBlocThingsTextState() {
    if (blocThings.things.length > 0) {
      return Text(
        blocThings.checkedCount.toString(),
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
        style: TextStyle(
          fontFamily: DayByDayAppTheme.fontFamilyBigShouldersStencilText,
          fontSize: 20,
        ),
      );
    }
  }

  Widget _changeBlocThingsiconState() {
    if (blocThings.things.length > 0 &&
        (blocThings.things.length == blocThings.checkedCount)) {
      return Icon(
        DayByDayRessources.iconRessourceStatusDone,
        size: 25,
      );
    } else if (blocThings.things.length > 0) {
      return Icon(
        DayByDayRessources.iconRessourceStatusInProgress,
        size: 25,
      );
    } else {
      return Icon(
        DayByDayRessources.iconRessourceStatusEmpty,
        size: 25,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: _changeBlocThingsiconState(),
              ),
              Container(
                height: 60,
                width: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: _changeBlocThingsTextState(),
                    ),
                    Text(
                      "/",
                      style: TextStyle(
                        fontFamily:
                            DayByDayAppTheme.fontFamilyBigShouldersStencilText,
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
            ],
          ),
        ],
      ),
    );
  }
}
