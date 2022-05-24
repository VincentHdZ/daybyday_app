import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/blocthings.dart';

import '../../services/providers/blocs_things.dart';

import '../../utils/daybyday_theme_app.dart';
import '../../utils/daybyday_resources.dart';

class EditBlocThingsModalBottomSheet extends StatefulWidget {
  final BlocThings _selectedBlocThings;
  final Function(String) updateBlocThingsTitleAppBar;

  EditBlocThingsModalBottomSheet(
    this._selectedBlocThings,
    this.updateBlocThingsTitleAppBar,
  );

  @override
  _EditBlocThingsModalBottomSheetState createState() =>
      _EditBlocThingsModalBottomSheetState();
}

class _EditBlocThingsModalBottomSheetState
    extends State<EditBlocThingsModalBottomSheet> {
  BlocThings _editedBlocThings = new BlocThings();
  final _formKey = GlobalKey<FormState>();
  String _initialValue = '';
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget._selectedBlocThings != null) {
        _initialValue = widget._selectedBlocThings.title;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _initialValue,
                keyboardType: TextInputType.text,
                cursorColor: Color.fromRGBO(0, 176, 255, 0.9),
                autofocus: true,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15),
                  hintText: DayByDayRessources
                      .textRessourceHintTextModalBottomSheetCreateNewListThings,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return DayByDayRessources
                        .textRessourceValidatorMessageTitleNewListThings;
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedBlocThings = new BlocThings(
                    id: widget._selectedBlocThings.id,
                    title: value,
                    state: widget._selectedBlocThings.state,
                    things: widget._selectedBlocThings.things,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _isLoading
                    ? Padding(
                        padding: EdgeInsets.only(right: 25, bottom: 25),
                        child: CircularProgressIndicator(
                          backgroundColor: DayByDayAppTheme.accentColor,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          child: Text(
                            DayByDayRessources.textRessourceSaveButton,
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(0, 176, 255, 0.9),
                            ),
                          ),
                          onPressed: () {
                            _saveForm();
                          },
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveForm() async {
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        _setStateCircularProgressIndicator(true);
        await Provider.of<BlocsThings>(context, listen: false)
            .updateBlocThings(_editedBlocThings);
        widget.updateBlocThingsTitleAppBar(_editedBlocThings.title);
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
              DayByDayRessources.textRessourceAlertDialogTitleErrorMessage),
          content: Text(
              DayByDayRessources.textRessourceAlertDialogContentErrorMessage),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: DayByDayAppTheme.accentColor,
              ),
              child: Text(DayByDayRessources.textRessourceOk),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    } finally {
      if (_isLoading) {
        _setStateCircularProgressIndicator(false);
        Navigator.of(context).pop();
      }
    }
  }

  void _setStateCircularProgressIndicator(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }
}
