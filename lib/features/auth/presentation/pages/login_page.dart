/* V 01.00
   Login page 
  :- user can login.
  :- user can register.
  on coming update V 02.0 

  :- forgot pass 
  :- design update.
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_circle/features/auth/presentation/components/mt_textbox.dart';
import 'package:peer_circle/features/auth/presentation/components/my_button.dart';
import 'package:peer_circle/features/auth/presentation/cubits/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePage;
  const LoginPage({super.key, required this.togglePage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers ..
  final emailController = TextEditingController();
  final pwsController = TextEditingController();

  // login method.

  void login() {
    final String email = emailController.text;
    final String pws = pwsController.text;

    final authCubit = context.read<AuthCubit>();

    // validating email and password.
    if (email.isNotEmpty && pws.isNotEmpty) {
      authCubit.login(email, pws);
    } else {
      // return a error message to the users.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Pleas enter both email and password.")));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    pwsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              //setting  logo
              Icon(
                Icons.lock_open_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 50,
              ),
              const Text("Welcome back, you've been missed!"),
              const SizedBox(
                height: 10,
              ),
              MyTextBox(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false),
              const SizedBox(
                height: 50,
              ),
              MyTextBox(
                  controller: pwsController,
                  hintText: "Password",
                  obscureText: true),
              const SizedBox(
                height: 50,
              ),
              MyButton(
                onTap: login,
                text: "Login",
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member ? ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: widget.togglePage,
                    child: Text(
                      " Register",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
