/*
Auth page - this pages  
*/

import 'package:flutter/material.dart';
import 'package:peer_circle/features/auth/presentation/pages/login_page.dart';
import 'package:peer_circle/features/auth/presentation/pages/regessrter_page.dart';

class AuthPages extends StatefulWidget {
  const AuthPages({super.key});

  @override
  State<AuthPages> createState() => _AuthPagesState();
}

class _AuthPagesState extends State<AuthPages> {
  bool showLoginPage = true;

  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        togglePage: togglePage,
      );
    } else {
      return RegessrterPage(
        togglePage: togglePage,
      );
    }
  }
}
