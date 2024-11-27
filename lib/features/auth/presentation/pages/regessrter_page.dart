import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_circle/features/auth/presentation/components/mt_textbox.dart';
import 'package:peer_circle/features/auth/presentation/components/my_button.dart';
import 'package:peer_circle/features/auth/presentation/cubits/auth_cubit.dart';

class RegessrterPage extends StatefulWidget {
  final void Function()? togglePage;
  const RegessrterPage({super.key, required this.togglePage});

  @override
  State<RegessrterPage> createState() => _RegessrterPageState();
}

class _RegessrterPageState extends State<RegessrterPage> {
  // controller

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final pwsController = TextEditingController();
  final conformPwsController = TextEditingController();
  final collageController = TextEditingController();
  final campusController = TextEditingController();
  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String pws = pwsController.text;
    final String conformPws = conformPwsController.text;
    final String Collage = collageController.text;
    final String campus = campusController.text;

    final authCubit = context.read<AuthCubit>();

    // validation
    if (email.isNotEmpty &&
        name.isNotEmpty &&
        pws.isNotEmpty &&
        conformPws.isNotEmpty &&
        Collage.isNotEmpty &&
        campus.isNotEmpty) {
      //pass
      if (pws == conformPws) {
        authCubit.register(name, email, Collage, campus, pws);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pleas fill all fields.")));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    pwsController.dispose();
    conformPwsController.dispose();
    collageController.dispose();
    campusController.dispose();
    super.dispose();
    // disposing all data .
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
              //setting  logo
              Icon(
                Icons.lock_open_rounded,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text("Welcome to PeerCircle"),
              const SizedBox(
                height: 10,
              ),
              MyTextBox(
                  controller: nameController,
                  hintText: "Name",
                  obscureText: false),
              const SizedBox(
                height: 20,
              ),
              MyTextBox(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false),
              const SizedBox(
                height: 20,
              ),
              MyTextBox(
                  controller: pwsController,
                  hintText: "Password",
                  obscureText: true),
              const SizedBox(
                height: 20,
              ),
              MyTextBox(
                  controller: conformPwsController,
                  hintText: "Conform Password",
                  obscureText: true),
              const SizedBox(
                height: 20,
              ),
              MyTextBox(
                  controller: collageController,
                  hintText: "Collage Name ",
                  obscureText: false),
              const SizedBox(
                height: 20,
              ),
              MyTextBox(
                  controller: campusController,
                  hintText: "Campus Name",
                  obscureText: false),
              const SizedBox(
                height: 20,
              ),
              MyButton(
                onTap: register,
                text: "Sign Up",
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member  ? ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: widget.togglePage,
                    child: Text(
                      " Login",
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
