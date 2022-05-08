import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:provider/provider.dart';

import '../../services/providers/blocsthings.dart';
import '../../services/providers/things.dart';
import '../../services/providers/auth.dart';

import '../../models/blocthings.dart';

import '../../utils/daybyday_resources.dart';
import '../../utils/daybyday_theme_app.dart';

import '../widgets/create_blocthings_modal_bottom_sheet.dart';
import '../widgets/blocsthings_image.dart';
import '../widgets/blocthings_gridview.dart';
import '../widgets/edit_blocthings_overview_modal_bottom_sheet.dart';

class BlocThingsOverviewPage extends StatefulWidget {
  @override
  _BlocThingsOverviewPageState createState() => _BlocThingsOverviewPageState();
}

class _BlocThingsOverviewPageState extends State<BlocThingsOverviewPage> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<BlocsThings>(context).fetchAndSetBlocsThings();
      Provider.of<Things>(context).fetchAndSetThings().then((_) => {
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
    final List<BlocThings> blocThings = Provider.of<BlocsThings>(context).items;

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
          : _getBodyContent(blocThings),
      floatingActionButton: _getFloatingActionButton(),
    );
  }

  Widget _buttonLogout() {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
            icon: Icon(
              Icons.logout,
            ),
            onPressed: () {
              Provider.of<Auth>(context, listen: false).logout();
            });
      },
    );
  }

  Widget _getBodyContent(List<BlocThings> blocThings) {
    if (blocThings != null && blocThings.length > 0) {
        return BlocThingsGridview(_showModalFormEditBlocThings);
    }

    return BlocsThingsImage();
  }

  void _showModalFormEditBlocThings(BuildContext ctx, BlocThings blocThings) {
    BlocThings editedBlocThings = new BlocThings(
      id: blocThings.id,
      title: blocThings.title,
      checkedCount: blocThings.checkedCount,
      state: blocThings.state,
      things: blocThings.things,
    );

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
        return EditBlocThingsOverviewModalBottomSheet(editedBlocThings);
      },
    );
  }

  Widget _getFloatingActionButton() {
    return FloatingActionButton(
      elevation: 3,
      onPressed: () {
        _showModalFormCreateNewBlocThings(context);
      },
      child: Icon(
        Icons.create_sharp,
        size: ScreenUtil().setWidth(60),
        color: DayByDayAppTheme.accentColor,
      ),
    );
  }

  void _showModalFormCreateNewBlocThings(BuildContext ctx) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      elevation: 3,
      context: ctx,
      builder: (BuildContext ctx) {
        return CreateBlocThingsModalBottomSheet();
      },
    );
  }
}
