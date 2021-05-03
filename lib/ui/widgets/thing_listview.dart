import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:daybyday_app/ui/widgets/thing_card.dart';

import '../../models/blocthings.dart';

import 'package:daybyday_app/services/providers/things.dart';

class ThingListView extends StatelessWidget {
  final BlocThings _thingsList;

  ThingListView(this._thingsList);

  @override
  Widget build(BuildContext context) {
    final things = Provider.of<Things>(context, listen: true)
        .findByBlocThingsId(_thingsList.id);
    return Flexible(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: things.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: things[i],
          child: ThingCard(),
        ),
      ),
    );
  }
}
