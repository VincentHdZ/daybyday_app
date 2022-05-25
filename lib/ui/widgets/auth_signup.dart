import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/providers/auth.dart';

import '../../models/http_exception.dart';

import '../../utils/daybyday_theme_app.dart';

class AuthSignUp extends StatefulWidget {
  final Function setAuthMode;

  AuthSignUp(this.setAuthMode);

  @override
  _AuthSignUpState createState() => _AuthSignUpState();
}

class _AuthSignUpState extends State<AuthSignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                _authData['email'] = value;
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
              controller: _passwordController,
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
                if (value.isEmpty || value.length < 5) {
                  return "Password to short";
                }
                return null;
              },
              onSaved: (value) {
                _authData['password'] = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Confirm Password",
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
                  hintText: "Confirm Password",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0))),
              validator: (value) {
                if (value != _passwordController.text) {
                  return "Passwords do not match";
                }
                return null;
              },
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.blue[50],
                    elevation: 15,
                    padding: const EdgeInsets.only(
                        left: 80.0, top: 10.0, right: 80.0, bottom: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onPressed: () {
                    _signUp();
                  },
                  child: _isLoading
                      ? Padding(
                          padding: EdgeInsets.only(right: 0, bottom: 0),
                          child: CircularProgressIndicator(
                              backgroundColor: DayByDayAppTheme.accentColor),
                        )
                      : const Text(
                          'Sign Up',
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 20),
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
                  "I have an account",
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
                    "Sign In",
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
    );
  }

  bool _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    return (!regex.hasMatch(value)) ? false : true;
  }

  Future<void> _signUp() async {
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      String errorMessage = 'Signup failed';

      if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }

      _showErrorDialog(errorMessage);
    } catch (error) {
      String errorMessage = 'Sign up failed. Please try again later.';

      _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        if (_isLoading) {
          _isLoading = false;
          widget.setAuthMode();
        }
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
          TextButton(
            child: Text(
              'Okay',
              style: TextStyle(
                color: DayByDayAppTheme.accentColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
