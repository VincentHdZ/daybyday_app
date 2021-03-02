import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../services/providers/blocsthings.dart';

import '../../ui/widgets/thing_listview.dart';

import '../../models/blocthings.dart';

import '../../utils/daybyday_theme_app.dart';

import '../widgets/blocthings_image.dart';
import '../widgets/blocthings_popup_menu_button.dart';
import '../widgets/create_thing_modal_bottom_sheet.dart';
import '../widgets/blocthings_counter.dart';

class BlocThingsDetailsPage extends StatefulWidget {
  static final String routeName = "/detailsThingsListPage";

  @override
  _BlocThingsDetailsPageState createState() => _BlocThingsDetailsPageState();
}

class _BlocThingsDetailsPageState extends State<BlocThingsDetailsPage> {
  BlocThings _selectedBlocThings;
  String _blocThingsTitleAppBar;
  bool _init = true;
  void _setStatBlocThingsTitleAppBar(String titleUpdate) {
    setState(() {
      _blocThingsTitleAppBar = titleUpdate;
    });
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      final String selectedBlocThingsId =
          ModalRoute.of(context).settings.arguments as String;
      _selectedBlocThings = Provider.of<BlocsThings>(
        context,
        listen: true,
      ).findById(selectedBlocThingsId);
      _blocThingsTitleAppBar = _selectedBlocThings.title;
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_blocThingsTitleAppBar),
        leading: BackButton(
          color: DayByDayAppTheme.accentColor,
        ),
        actions: [
          BlocThingsPopupMenuButton(
              _selectedBlocThings, _setStatBlocThingsTitleAppBar),
        ],
      ),
      body: _getBodyContent(),
      floatingActionButton: _getFloatingActionButton(),
    );
  }

  Widget _getBodyContent() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: Container(
            height: viewportConstraints.maxHeight,
            child: Column(
              children: [
                BlocThingsCounter(_selectedBlocThings),
                _selectedBlocThings.things.length > 0
                    ? ThingListView(_selectedBlocThings)
                    : Expanded(child: BlocThingsImage()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getFloatingActionButton() {
    return FloatingActionButton(
      elevation: 3,
      onPressed: () {
        _showModalFormCreateNewThing(context);
      },
      child: Icon(
        Icons.add,
        size: ScreenUtil().setWidth(60),
        color: DayByDayAppTheme.accentColor,
      ),
    );
  }

  void _showModalFormCreateNewThing(BuildContext ctx) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      elevation: 3,
      isScrollControlled: true,
      context: ctx,
      builder: (BuildContext ctx) {
        return CreateThingModalBottomSheet(_selectedBlocThings);
      },
    );
  }
}
