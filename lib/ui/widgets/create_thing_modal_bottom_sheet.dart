import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/providers/blocs_things.dart';
import '../../services/providers/things.dart';

import '../../models/blocthings.dart';
import '../../models/thing.dart';

import '../../utils/daybyday_theme_app.dart';
import '../../utils/daybyday_resources.dart';

import 'datepicker_formfield.dart';

class CreateThingModalBottomSheet extends StatefulWidget {
  final BlocThings _selectedBlocThings;

  CreateThingModalBottomSheet(this._selectedBlocThings);

  @override
  _CreateThingModalBottomSheetState createState() =>
      _CreateThingModalBottomSheetState();
}

class _CreateThingModalBottomSheetState
    extends State<CreateThingModalBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _labelThingTextController = new TextEditingController();
  final TextEditingController _deadlineDateTimeTextController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveForm() async {
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        _setStateCircularProgressIndicator(true);

        final DateFormat dateTimeFormatter = DateFormat('dd/MM/yyyy');
        final Thing newThing = new Thing(
          label: _labelThingTextController.text,
          deadline: _deadlineDateTimeTextController.text.isEmpty
              ? null
              : dateTimeFormatter.parse(_deadlineDateTimeTextController.text),
          blocThingsId: widget._selectedBlocThings.id,
        );

        await Provider.of<Things>(context, listen: false)
            .addThing(newThing)
            .then((_) {
          final Thing createdThing =
              Provider.of<Things>(context, listen: false).items.last;
          Provider.of<BlocsThings>(context, listen: false).addThingToBlocThings(
              widget._selectedBlocThings.id, createdThing);
        });
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  cursorColor: Color.fromRGBO(0, 176, 255, 0.9),
                  autofocus: true,
                  controller: _labelThingTextController,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15),
                    hintText: DayByDayRessources
                        .textRessourceHintTextModalBottomSheetCreateNewThing,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return DayByDayRessources
                          .textRessourceValidatorMessageTitleNewListThings;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _labelThingTextController.text = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DatePickerFormField(
                      birthdayController: _deadlineDateTimeTextController,
                    ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setStateCircularProgressIndicator(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }
}
