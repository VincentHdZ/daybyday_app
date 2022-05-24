import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/blocthings.dart';

import '../../services/providers/blocs_things.dart';

import '../../utils/daybyday_resources.dart';
import '../../utils/daybyday_theme_app.dart';

class EditBlocThingsOverviewModalBottomSheet extends StatefulWidget {
  final BlocThings editedBlocThings;

  EditBlocThingsOverviewModalBottomSheet(this.editedBlocThings);
  @override
  _EditBlocThingsOverviewModalBottomSheetState createState() =>
      _EditBlocThingsOverviewModalBottomSheetState();
}

class _EditBlocThingsOverviewModalBottomSheetState
    extends State<EditBlocThingsOverviewModalBottomSheet> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: widget.editedBlocThings.title,
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
                  widget.editedBlocThings.title = value;
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
      if (formKey.currentState.validate()) {
        formKey.currentState.save();
        _setStateCircularProgressIndicator(true);
        await Provider.of<BlocsThings>(context, listen: false)
            .updateBlocThings(widget.editedBlocThings);
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
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text(DayByDayRessources.textRessourceOk),
            ),
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
