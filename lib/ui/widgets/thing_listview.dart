import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/blocthings.dart';

import '../../services/providers/things.dart';

import '../../ui/widgets/thing_card.dart';

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
