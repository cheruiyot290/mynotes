import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import '../utilities/show_error_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        title: const Text('Login Page'),
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
                    const Icon(Icons.login, size: 150,),
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
                            icon: Icon(Icons.password,),
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
                                await AuthService.firebase().logIn(email: email, password: password);
                                final user = AuthService.firebase().currentUser;
                                if(user!.isEmailVerified == true){
                                  Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                                }else{
                                  AuthService.firebase().sendEmailVerification();
                                  Navigator.of(context).pushNamed('/verify/');
                                }
                              }on InvalidLoginCredentialsException{
                                await showErrorDialog(context, 'Please make sure your password is correct');
                              } on InvalidEmailException {
                                await showErrorDialog(context, 'Please enter a valid email address');
                              }on MissingPasswordException{
                                await showErrorDialog(context, 'Please enter a password');
                              }on ChannelErrorException{
                                await showErrorDialog(context, "Please ensure you have an internet connection and you've filled all the fields correctly" );
                              }on INVALID_LOGIN_CREDENTIALS{
                                await showErrorDialog(context, "Invalid login credentials" );
                              }on NetworkRequestFailedException{
                                await showErrorDialog(context, 'Please ensure you have an internet connection');
                              }on GenericAuthException{
                                await showErrorDialog(context, 'Failed to login!');
                              }
                            },
                            child: const Text("Login"))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                        },
                        child: const Text(
                            "Don't Have An Account? Click Here To Register"))
                  ],
                ),
              ),
            )
          ],

        ),
      ),
    );

  }
}
