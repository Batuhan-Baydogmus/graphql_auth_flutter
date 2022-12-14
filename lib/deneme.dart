import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var password;
  var username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Form(
          key: _formKey,
          //Container is for position adjustment problem column.
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _resultApi(),
                Text(
                  'Please enter your information',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  //Container for circular look, color and auto size adjustment for textfield.
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 199, 210, 219),
                        borderRadius: BorderRadius.circular(6)),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelText: "User Name",
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        username = value;
                      },
                    ),
                  ),
                ),
                //sized box for space between two texfield.
                SizedBox(
                  height: 10,
                ),
                // Second textield for password.
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 150, 170, 185),
                        borderRadius: BorderRadius.circular(6)),
                    child: TextFormField(
                      //style: TextStyle(color: Color.fromARGB(255, 163, 35, 35)),

                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.2)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        password = value;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _loginButton(),
                ),
              ],
            ),
          )),
    );
  }

  Widget _loginButton() => RaisedButton(
      color: Color.fromARGB(255, 21, 75, 97),
      child: Text(
        "Submit",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState?.save();

          //Console print for test
          debugPrint("username:$username, password:$password");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 2),
            // Alignment with row centered text.
            //Dont forget the ADD float snackbar adjustment after integration GraphQL.
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("username:$username,  password:$password"),
              ],
            ),
          ));
        }
      });
  Widget _resultApi() => Text("username:$username, password:$password");
}
