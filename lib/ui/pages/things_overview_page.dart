import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/providers/blocs_things.dart';
import '../../services/providers/things.dart';

import '../../models/blocthings.dart';
import '../../models/thing.dart';

import '../../utils/daybyday_theme_app.dart';

import '../widgets/thing_card.dart';

class ThingsOverviewPage extends StatefulWidget {
  @override
  State<ThingsOverviewPage> createState() => _ThingsOverviewPageState();
}

class _ThingsOverviewPageState extends State<ThingsOverviewPage> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<BlocsThings>(context, listen: false)
          .fetchAndSetBlocsThings()
          .then((_) =>
              Provider.of<Things>(context, listen: false).fetchAndSetThings())
          .then((_) => {
                setState(() {
                  _isLoading = false;
                })
              });

      _isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final List<Thing> things = Provider.of<Things>(context, listen: true).items;
    List<BlocThings> blocsThings = Provider.of<BlocsThings>(context).items;
    List<Thing> allThings = [];

    blocsThings.forEach((bloc) {
      bloc.things = Provider.of<Things>(context)
          .findByBlocThingsId(bloc.id)
          .where((element) =>
              element.deadline?.toIso8601String()?.split('T')?.first ==
              DateTime.now().toIso8601String().split('T').first && !element.isChecked)
          .toList();
    });
    blocsThings.forEach((bloc) {
      bloc.things.forEach((thing) {
        allThings.add(thing);
      });
    });

    return Scaffold(
        body: _isLoading
            ? Center(
                child: Container(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    backgroundColor: DayByDayAppTheme.accentColor,
                    strokeWidth: 10,
                  ),
                ),
              )
            : (allThings.length > 0
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: allThings.length,
                    itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: allThings[i],
                      child: ThingCard(),
                    ),
                  )
                : Center(
                    child: Container(child: Text('No Todo this day')),
                  )));
  }
}
