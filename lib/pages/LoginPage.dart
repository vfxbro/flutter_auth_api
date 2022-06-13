import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late SharedPreferences prefs;

  _initPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _initPref();
  }

  _login(var values) async {
    var url = Uri.parse('https://elistore.ru/api/v1/auth/');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json-patch+json',
        'accept': 'application/json',
        "X-PI-EMAIL": values['username'],
        "X-PI-PASSWORD": values['password'],
      },
    );

    var body = convert.jsonDecode(response.body);

    int userId = body['result']['id'];
    String tokenKey = body['result']['key'];

    if (response.statusCode == 200) {
      print("Logged In");
      print(userId);
      print(tokenKey);

      //save token to pref
      await prefs.setString('$tokenKey', response.body);
      print(prefs.getString('$tokenKey'));

      //get profile
      _getProfile(tokenKey);
    } else {
      print(body['message']);

      final snackBar = SnackBar(content: Text(body['message']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _getProfile($tokenKey) async {
    //get token from pref
    var tokenString = prefs.getString($tokenKey);
    var token = convert.jsonDecode(tokenString!);
    print(token['result']['key']);

    //http get profile
    var url = Uri.parse('https://elistore.ru/api/v1/user/');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer ${token['result']['key']}',
        "X-PI-KEY": $tokenKey,
        'id': '15',
      },
    );
    var body = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      print('ok');

      Navigator.pushNamed(
        context,
        '/launcher',
      );
      print(body['result']['name']);
    } else {
      print('fail');
      print(body['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.blue,
              Colors.white,
            ])),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/profile.png'),
                  height: 100,
                ),
                Text('Login',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FormBuilder(
                    key: _formKey,
                    initialValue: {'username': '', 'password': ''},
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'username',
                          decoration: InputDecoration(
                            labelText: 'Email',
                            filled: true,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'please insert email'),
                            FormBuilderValidators.email(context),
                            // FormBuilderValidators.numeric(context),
                            // FormBuilderValidators.max(context, 70),
                          ]),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          name: 'password',
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'password',
                            filled: true,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'please insert password'),
                            FormBuilderValidators.minLength(context, 6,
                                errorText: 'min length 8 character'),
                          ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child: MaterialButton(
                            onPressed: () {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                print(_formKey.currentState!.value);
                                _login(_formKey.currentState!.value);
                              } else {
                                print("validation failed");
                              }
                            },
                            child: Text("Login",
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            // Expanded(
                            //     child: MaterialButton(
                            //   onPressed: () {
                            //     // Navigator.pushNamed(context, '/register');
                            //   },
                            //   child: Text('Forgot Password',
                            //       style: TextStyle(color: Colors.blue)),
                            // )),
                            Expanded(
                                child: MaterialButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text('Register User',
                                  style: TextStyle(color: Colors.blue)),
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
