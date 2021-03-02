import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/daybyday_theme_app.dart';
import '../../utils/daybyday_resources.dart';

class BlocsThingsImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(950),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: Image.asset(
                  DayByDayRessources.imageRessourceThings,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Column(
                  children: [
                    Text(
                      DayByDayRessources.textRessourceCitation,
                      style: TextStyle(
                        fontFamily: DayByDayAppTheme.fontFamilyPlayfairDispley,
                        fontSize: ScreenUtil().setWidth(36),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          DayByDayRessources.textRessourceAutorCitation,
                          style: TextStyle(
                            fontFamily:
                                DayByDayAppTheme.fontFamilyPlayfairDispley,
                            fontSize: ScreenUtil().setWidth(24),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
