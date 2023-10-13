import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import '../services/auth/auth_exceptions.dart';
import '../utilities/show_error_dialog.dart';
import 'login.dart';
import 'dart:developer' as devtools show log;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Icon(Icons.app_registration,size: 150,),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          enableSuggestions: false,
                          autocorrect: false,
                          
                          decoration: const InputDecoration(
                              icon: Icon(Icons.email,),
                              border: OutlineInputBorder(),
                              hintText: "Enter Email",
                              labelText: "Email"),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.password),
                          border: OutlineInputBorder(),
                          hintText: "Enter Password",
                          labelText: "Password",
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 100,
                      height: 50,
                    ),
                    SizedBox(
                        child: ElevatedButton(
                            onPressed: () async {
                              final email = _email.text;
                              final password = _password.text;
                              try{
                                await AuthService.firebase().createUser(email: email, password: password);
                                await AuthService.firebase().sendEmailVerification();

                                Navigator.of(context).pushNamed('/verify/');
                              }on WeakPasswordException{
                                await showErrorDialog(context, 'Weak Password!');
                              } on InvalidEmailException {
                                await showErrorDialog(context, 'Please enter a valid email address');
                              }on MissingPasswordException{
                                await showErrorDialog(context, 'Please enter a password');
                              }on ChannelErrorException{
                                await showErrorDialog(context, "Please ensure you have an internet connection and you've filled all the fields correctly" );
                              }on EmailAlreadyInUseException{
                                await showErrorDialog(context, 'Email already registered!');
                              }on NetworkRequestFailedException{
                                await showErrorDialog(context, 'Please ensure you have an internet connection');
                              }on GenericAuthException{
                                await showErrorDialog(context, 'Failed to register!');
                              }

                            },
                            child: const Text("Register"))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                        },
                        child: const Text(
                            "Have An Account? Click Here To Login"))
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
