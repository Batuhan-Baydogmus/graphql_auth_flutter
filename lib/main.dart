import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:video_player/video_player.dart';
import 'secondpage.dart';

const productsGraphQL = """
query products{
products(first:30, channel: "default-channel"){
    edges {
      node {
        id
        name
        description
        thumbnail {
          url
        }
      }
    }
  }
}
""";

void main() {
  final HttpLink httpLink = HttpLink("https://demo.saleor.io/graphql/");
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );

  var app = GraphQLProvider(client: client, child: MyApp());

  runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  //String? password;
  // String? username;
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isIconVisible = false;
  bool isIconVisible1 = false;
  bool hidePassword = true;
  final _formKey = GlobalKey<FormState>();
  String? password;
  String? username;
  final VideoPlayerController _video =
      VideoPlayerController.asset('assets/videos/New.mp4');

  @override
  void initState() {
    super.initState();
    _video.setVolume(0);
    _video.setLooping(true);
    _video.play();
    _video.initialize().then((void value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        /*  Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ), */
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _video.value.size.width,
              height: _video.value.size.height,
              child: VideoPlayer(_video),
            ),
          ),
        ),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Form(
              key: _formKey,
              //Padding for username text and button's container position.
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 180, left: 260, right: 260, bottom: 180),
                  //Container is for position adjustment problem column.
                  child: Container(
                      decoration: BoxDecoration(
                          color:
                              Color.fromARGB(255, 76, 68, 68).withOpacity(0.4),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.3)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Container for the alignment text.
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Please enter your information ;',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
// SizedBox(height: 1),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 100, right: 100),
                            //Container for circular look, color and auto size adjustment for textfield.
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 165, 165, 165)
                                      .withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(6)),
                              child: TextFormField(
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      isIconVisible1 = true;
                                    });
                                  } else {
                                    setState(() {
                                      isIconVisible1 = false;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: isIconVisible1
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.black,
                                          )
                                        : null,
                                    labelText: "User Name",
                                    labelStyle: TextStyle(color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.2))),
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
                          SizedBox(
                            height: 10,
                          ),
                          // Second textield for password.
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 100, right: 100),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 165, 165, 165)
                                      .withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(6)),
                              child: TextFormField(
                                //style: TextStyle(color: Color.fromARGB(255, 163, 35, 35)),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      isIconVisible = true;
                                    });
                                  } else {
                                    setState(() {
                                      isIconVisible = false;
                                    });
                                  }
                                },
                                obscureText: hidePassword,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    //PrefixIcon used, because normal icon not fitted inside the input borders.
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: isIconVisible
                                        ? IconButton(
                                            color: Colors.black,
                                            onPressed: () {
                                              setState(() {
                                                hidePassword = !hidePassword;
                                              });
                                            },
                                            icon: Icon(
                                              hidePassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                          )
                                        : null,
                                    labelText: "Password",
                                    labelStyle: TextStyle(color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter your password';
                                  } else if (value.length < 6) {
                                    return 'Password is too short';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  password = value;
                                },
                              ),
                            ),
                          ),
// Login and forgot button section
                          Padding(
                            padding: const EdgeInsets.only(right: 50, top: 10),
                            child: _loginButton(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 50, top: 10),
                            child: _forgotButton(),
                          ),
                        ],
                      )),
                ),
              ))
        ]),
      ],
    ));
  }

  Future<String?> _loadData() async {
    final String response = await rootBundle.loadString('user.json');
    final data = await json.decode(response);
    return data['username'];
  }

  Future<String?> _loadData2() async {
    final String response = await rootBundle.loadString('user.json');
    final data = await json.decode(response);
    return data['password'];
  }

// Container for button shadow.- blur radius for blur effect

  Widget _loginButton() => Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black, blurRadius: 20, offset: Offset(0, 5))
          ],
        ),
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
            child: Text(
              "Submit",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                var get_user = await _loadData();
                var get_password = await _loadData2();
                print(get_password);
// usernameyi json dan okuyorum
                if (get_user == username && get_password == password) {
                  // burda gelen değerle json u karşılarştırıyorum eğer eşitse diğer sayfaya gidiyor.
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SecondPage(
                                username: username,
                                password: 'batu',
                              )));
                } else {
                  print("Giriş Başarısız");
                }
                //Console print for testT
                // debugPrint("username:$username, password:$password");

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
            }),
      );
  // Widget _resultApi() => Text("username:$username, password:$password");
}

Widget _forgotButton() => TextButton(
      onPressed: () {},
      child: Text(
        'Forgot Your Password ?',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
