import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  _register(var values) async {
    var url = Uri.parse('https://elistore.ru/api/v1/register/');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode({
          'email': values['email'],
          'name': values['name'],
          'phone': values['phone']
        }));

    var body = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(response.body);
      final snackBar =
          SnackBar(content: Text('${body['email']} is registered'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    } else {
      print(body['message']);

      final snackBar =
          SnackBar(content: Text('${values['email']} is not registered'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('RegisterPage'),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FormBuilder(
                    key: _formKey,
                    initialValue: {
                      'email': '',
                      'name': '',
                      'phone': '',
                    },
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'email',
                          decoration: InputDecoration(
                            labelText: 'Email',
                            filled: true,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'please insert email'),
                            FormBuilderValidators.email(context),
                          ]),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          name: 'name',
                          decoration: InputDecoration(
                            labelText: 'name',
                            filled: true,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'please insert name'),
                          ]),
                        ),
                        SizedBox(height: 15),
                        FormBuilderTextField(
                          name: 'phone',
                          decoration: InputDecoration(
                            labelText: 'phone',
                            filled: true,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'please insert phone'),
                          ]),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                                child: MaterialButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  print('register');
                                  _formKey.currentState!.save();
                                  _register(_formKey.currentState!.value);
                                } else {
                                  print("validation failed");
                                }
                              },
                              child: Text('Register',
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
        ));
  }
}
