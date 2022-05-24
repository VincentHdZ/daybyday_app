import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/providers/blocs_things.dart';

import '../../models/blocthings.dart';

import 'blocthings_card.dart';

class BlocThingsGridview extends StatelessWidget {
  final Function handleFunc;

  BlocThingsGridview(this.handleFunc);

  @override
  Widget build(BuildContext context) {
    final blocThingsData = Provider.of<BlocsThings>(context);
    final List<BlocThings> blocThings = blocThingsData.items;

    return GridView.builder(
      itemCount: blocThings.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: blocThings[i],
        child: BlocThingsCard(handleFunc),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 1,
      ),
    );
  }
}
