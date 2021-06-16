import 'package:battery_manager/constants/constants.dart';
import 'package:battery_manager/constants/loading.dart';
import 'package:battery_manager/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  //const SignIn({Key? key}) : super(key: key);

  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: secondary_bg_color,
            appBar: AppBar(
              backgroundColor: secondary_bg_color,
              elevation: 0.0,
              title: Text('Sign in'),
              actions: <Widget>[
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: secondary_bg_color,
                    ),
                    icon: Icon(Icons.person),
                    label: Text('Register'),
                    onPressed: () {
                      widget.toggleView();
                    })
              ],
            ),
            body: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/login.png"))),
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Hello, \nWelcome Back !",
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 1.0,
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 30.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    decoration:
                                        formFields.copyWith(hintText: 'Email'),
                                    validator: (val) =>
                                        val!.isEmpty ? 'Enter email' : null,
                                    onChanged: (val) {
                                      setState(() => email = val);
                                    },
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    decoration: formFields.copyWith(
                                        hintText: 'Password'),
                                    validator: (val) => val!.length < 4
                                        ? 'Password must be 4 characters or more'
                                        : null,
                                    obscureText: true,
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                  ),
                                  SizedBox(height: 20.0),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: secondary_green,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 15),
                                      ),
                                      child: Text(
                                        'Sign in',
                                        style: TextStyle(
                                            color: secondary_bg_color),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() => loading = true);
                                          dynamic result = await _auth
                                              .signInWithEmailAndPassword(
                                                  email, password);
                                          if (result == null) {
                                            setState(() {
                                              error =
                                                  'Log in failed! check your credentials';
                                              loading = false;
                                            });
                                          }
                                        }
                                      }),
                                  SizedBox(height: 12.0),
                                  Text(
                                    error,
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 14.0),
                                  )
                                ],
                              ),
                            )),
                      ]),
                ),
              ],
            ),
          );
  }
}
