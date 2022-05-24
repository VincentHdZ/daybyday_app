import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/blocthings.dart';

import '../../services/providers/blocs_things.dart';

import '../../utils/daybyday_theme_app.dart';
import '../../utils/daybyday_resources.dart';

class CreateBlocThingsModalBottomSheet extends StatefulWidget {
  @override
  _CreateBlocThingsModalBottomSheetState createState() =>
      _CreateBlocThingsModalBottomSheetState();
}

class _CreateBlocThingsModalBottomSheetState
    extends State<CreateBlocThingsModalBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _blocThingsTitleTextController =
      new TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  controller: _blocThingsTitleTextController,
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
                    _blocThingsTitleTextController.text = value;
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
                              _saveForm(context);
                            },
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveForm(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      try {
        _setStateCircularProgressIndicator(true);
        _formKey.currentState.save();

        BlocThings createdBlocThings = new BlocThings(
          title: _blocThingsTitleTextController.text,
          things: [],
        );

        await Provider.of<BlocsThings>(context, listen: false)
            .addBlocThings(createdBlocThings);
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
