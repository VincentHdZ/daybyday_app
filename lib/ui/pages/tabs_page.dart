import 'package:daybyday_app/services/providers/auth.dart';
import 'package:daybyday_app/ui/pages/blocthings_overview_page.dart';
import 'package:daybyday_app/ui/pages/things_overview_page.dart';
import 'package:daybyday_app/utils/daybyday_resources.dart';
import 'package:daybyday_app/utils/daybyday_theme_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _indexSelected = 0;
  final List<Map<String, Object>> _pages = [
    {
      'title': DayByDayRessources.textRessourceTitleThingsAppBar,
      'page': ThingsOverviewPage(),
    },
    {
      'title': DayByDayRessources.textRessourceTitleBlocThingsAppBar,
      'page': BlocThingsOverviewPage(),
    },
  ];

  void _indexSelectedChange(int index) {
    setState(() {
      _indexSelected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pages[_indexSelected]['title'],
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              }),
        ],
      ),
      body: _pages[_indexSelected]['page'],
      bottomNavigationBar: BottomNavigationBar(
          onTap: _indexSelectedChange,
          currentIndex: _indexSelected,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: DayByDayAppTheme.accentColor,
          unselectedItemColor: Colors.grey,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.today),
              label: "Things",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.notes),
              label: "Blocs",
            ),
          ]),
    );
  }
}
