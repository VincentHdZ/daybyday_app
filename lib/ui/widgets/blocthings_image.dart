import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import '../../utils/daybyday_resources.dart';

class BlocThingsImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: Image.asset(
                  DayByDayRessources.imageRessourceDetailsThings,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Column(
                  children: [
                    Text(
                      DayByDayRessources.textRessourceAddThings,
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(36),
                        fontWeight: FontWeight.w500,
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
