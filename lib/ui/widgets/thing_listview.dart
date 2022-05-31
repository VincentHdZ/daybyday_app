import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/blocthings.dart';

import '../../services/providers/things.dart';

import '../../ui/widgets/thing_card.dart';

class ThingListView extends StatelessWidget {
  final BlocThings _blocThings;

  ThingListView(this._blocThings);

  @override
  Widget build(BuildContext context) {
    final things = Provider.of<Things>(context, listen: true)
        .findByBlocThingsId(_blocThings.id);

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
