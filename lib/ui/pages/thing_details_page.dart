import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/widgets/datepicker_formfield.dart';

import '../../utils/daybyday_theme_app.dart';
import '../../utils/daybyday_resources.dart';

import '../../models/thing.dart';
import '../../models/blocthings.dart';

import '../../services/providers/blocsthings.dart';
import '../../services/providers/things.dart';

class ThingDetailsPage extends StatefulWidget {
  static final String routeName = "/detailsThingPage";

  @override
  _ThingDetailsPageState createState() => _ThingDetailsPageState();
}

class _ThingDetailsPageState extends State<ThingDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _deadlineDateTimeTextController =
      TextEditingController();
  final DateFormat _dateTimeFormatter = DateFormat('dd/MM/yyyy');
  Thing _selectedThing;
  BlocThings _blocThings;
  Map<String, dynamic> _initValues;
  bool _init = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_init) {
      final String selectedThingId = ModalRoute.of(context).settings.arguments as String;
      _selectedThing = Provider.of<Things>(context).findById(selectedThingId);
      _blocThings = Provider.of<BlocsThings>(context)
          .findById(_selectedThing.blocThingsId);
      _initValues = {
        'label': _selectedThing.label,
        'description': _selectedThing.description,
        'deadline': _selectedThing.deadline.toString(),
      };
      _deadlineDateTimeTextController.text = _selectedThing.deadline != null
          ? _dateTimeFormatter.format(_selectedThing.deadline)
          : "";
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
                _selectedThing.isChecked
                    ? Icons.restore
                    : Icons.check_circle_outline,
                size: 25,
                color: DayByDayAppTheme.accentColor,
              ),
              onPressed: () {
                setState(() {
                  _checkuncheck(context, _selectedThing);
                });
              }),
          IconButton(
              icon: Icon(
                Icons.delete,
                size: 25,
                color: Colors.redAccent[700],
              ),
              onPressed: () {
                _remove(context, _selectedThing, _blocThings);
              })
        ],
      ),
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
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      cursorColor: Color.fromRGBO(0, 176, 255, 0.9),
                      autofocus: false,
                      initialValue: _initValues['label'],
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 30),
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
                        _selectedThing = Thing(
                          id: _selectedThing.id,
                          label: value,
                          description: _selectedThing.description,
                          deadline: _selectedThing.deadline,
                          isChecked: _selectedThing.isChecked,
                          blocThingsId: _selectedThing.blocThingsId,
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 30.0,
                            right: 30.0,
                          ),
                          child: Icon(
                            Icons.description,
                            color: DayByDayAppTheme.accentColor,
                          ),
                        ),
                        Flexible(
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            cursorColor: Color.fromRGBO(0, 176, 255, 0.9),
                            maxLines: null,
                            initialValue: _initValues['description'],
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Saisir une description ",
                            ),
                            onSaved: (value) {
                              _selectedThing = Thing(
                                id: _selectedThing.id,
                                label: _selectedThing.label,
                                description: value,
                                deadline: _selectedThing.deadline,
                                isChecked: _selectedThing.isChecked,
                                blocThingsId: _selectedThing.blocThingsId,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DatePickerFormField(
                      birthdayController: _deadlineDateTimeTextController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            child: Text(
                              DayByDayRessources.textRessourceSaveButton,
                              style: TextStyle(
                                fontSize: 22,
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
            ),
    );
  }

  Future<void> _checkuncheck(BuildContext ctx, Thing thing) async {
    thing.toggleState();
    Provider.of<Things>(ctx, listen: false)
        .toggleStateThing(thing.id, thing.isChecked)
        .then((value) => Provider.of<BlocsThings>(ctx, listen: false)
            .updateBlocThingsCheckedCount(thing.blocThingsId));
  }

  Future<void> _remove(
      BuildContext context, Thing thing, BlocThings blocThings) async {
    final response = await _showAlertDialog(context, thing);
    if (response == 'yes') {
      try {
        Provider.of<Things>(context, listen: false)
            .revomeThing(thing.id)
            .then((_) => {
                  Provider.of<BlocsThings>(context, listen: false)
                      .removeThingFromBlocThings(blocThings.id, thing.id)
                })
            .then((value) => {
                  Provider.of<BlocsThings>(context, listen: false)
                      .updateBlocThingsCheckedCount(blocThings.id)
                });
      } catch (error) {
        // TODO
      } finally {
        Navigator.of(context).pop();
      }
    }
  }

  Future<String> _showAlertDialog(
      BuildContext context, Thing selectedThing) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(
              DayByDayRessources.textRessourceConfirmDeleteThingTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Text(
                "Vous confirmez la suppression de \"${selectedThing.label}\" ?",
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

  Future<void> _saveForm() async {
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        _setStateCircularProgressIndicator(true);
        _selectedThing.deadline = _deadlineDateTimeTextController.text != ""
            ? _dateTimeFormatter.parse(_deadlineDateTimeTextController.text)
            : null;
        await Provider.of<Things>(context, listen: false)
            .updateThing(_selectedThing);

        BlocThings blocThings = Provider.of<BlocsThings>(context, listen: false)
            .findById(_selectedThing.blocThingsId);
        final thingIndex = blocThings.things
            .indexWhere((element) => element.id == _selectedThing.id);
        blocThings.things[thingIndex] = _selectedThing;
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
      _setStateCircularProgressIndicator(false);
      Navigator.of(context).pop();
    }
  }

  void _setStateCircularProgressIndicator(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }
}
