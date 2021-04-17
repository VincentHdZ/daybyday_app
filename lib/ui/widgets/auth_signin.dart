import 'package:daybyday_app/models/http_exception.dart';
import 'package:daybyday_app/utils/daybyday_theme_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/providers/auth.dart';

class AuthSignIn extends StatefulWidget {
  final Function setAuthMode;

  AuthSignIn(this.setAuthMode);

  @override
  _AuthSignInState createState() => _AuthSignInState();
}

class _AuthSignInState extends State<AuthSignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        height: 350,
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.blue[300],
                    ),
                    hintText: "Your Email",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0))),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter your email";
                  }
                  if (!_validateEmail(value)) {
                    return "Invalid email";
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData["email"] = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.blue[300],
                    ),
                    hintText: "Your Password",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0))),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    elevation: 15,
                    onPressed: () {
                      _singin();
                    },
                    padding: const EdgeInsets.only(
                      left: 80.0,
                      top: 10.0,
                      right: 80.0,
                      bottom: 10.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    color: Colors.white,
                    splashColor: Colors.white,
                    highlightColor: Colors.blue[50],
                    child: _isLoading
                        ? Padding(
                            padding: EdgeInsets.only(right: 0, bottom: 0),
                            child: CircularProgressIndicator(
                              backgroundColor: DayByDayAppTheme.accentColor,
                            ),
                          )
                        : Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                            ),
                          ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Don't have an account ?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.setAuthMode();
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

  bool _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  Future<void> _singin() async {
    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });
        _formKey.currentState.save();
        await Provider.of<Auth>(context, listen: false)
            .signin(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Sign up failed. Please try again later.';
      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
