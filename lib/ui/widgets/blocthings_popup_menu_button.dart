import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/providers/blocsthings.dart';

import '../../models/blocthings.dart';

import '../../utils/daybyday_resources.dart';
import '../../utils/daybyday_theme_app.dart';

import 'edit_blocthings_modal_bottom_sheet.dart';

class BlocThingsPopupMenuButton extends StatelessWidget {
  final BlocThings _blocThings;
  final Function(String) _updateBlocThingsTitleAppBar;

  BlocThingsPopupMenuButton(
    this._blocThings,
    this._updateBlocThingsTitleAppBar,
  );

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (valueItemSelected) async {
        if (valueItemSelected == 0) {
          _showModalFormRenameTitleThingsList(context);
        } else if (valueItemSelected == 3) {
          final response = await _showAlertDialog(context, _blocThings);
          if (response == 'yes') {
            Provider.of<BlocsThings>(context, listen: false)
                .deleteBlocThings(_blocThings.id)
                .then((value) => Navigator.of(context).pop());
          }
        }
      },
      elevation: 3,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DayByDayRessources.textRessourcePopupMenuButtonRename,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Icon(
                DayByDayRessources.iconRessoureRename,
                size: 25,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DayByDayRessources.textRessourcePopupMenuButtonRemove,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Icon(
                DayByDayRessources.iconRessoureRemove,
                size: 25,
              ),
            ],
          ),
        ),
      ],
      icon: Icon(
        Icons.more_vert,
        size: 30,
      ),
    );
  }

  void _showModalFormRenameTitleThingsList(BuildContext ctx) {
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
        return EditBlocThingsModalBottomSheet(
            _blocThings, _updateBlocThingsTitleAppBar);
      },
    );
  }

  Future<String> _showAlertDialog(
      BuildContext context, BlocThings selectedThings) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(
              DayByDayRessources.textRessourceConfirmDeleteThingsListTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Text(
                "Vous confirmez la suppression de \"${selectedThings.title}\" ?",
                style: TextStyle(fontSize: 14),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'yes');
                },
                child: Text(
                  DayByDayRessources.textRessourceYes,
                  style: TextStyle(
                    color: DayByDayAppTheme.accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'no');
                },
                child: Text(
                  DayByDayRessources.textRessourceNo,
                  style: TextStyle(
                    color: DayByDayAppTheme.accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
