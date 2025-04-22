// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:talli_fitness/Components/my_button.dart';
import '/Components/my_textfield.dart';

// -----------------------------------------------------------------------------------
//                   Tutorial used to create Authentication Page
//                   https://www.youtube.com/watch?v=0RWLaJxW7Oc
// -----------------------------------------------------------------------------------

class LoginPage extends StatelessWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(224, 242, 241, 1),
        // appBar: AppBar(
        //   title: const Text("Tali Fitness"),
        //   centerTitle: true,
        //   backgroundColor: Colors.teal.shade200,
        // ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Center(
                  child: Icon(size: 80, Icons.person),
                ),
                SizedBox(height: 25),

                // App Name
                Text("Tali Fitness"),
                SizedBox(height: 25),

                // email Text field
                MyTextfield(
                    hintText: "Email",
                    obscureText: false,
                    controller: emailController),
                SizedBox(height: 10),

                // password Text field
                MyTextfield(
                    hintText: "Password",
                    obscureText: true,
                    controller: passwordController),
                SizedBox(height: 10),

                // forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text("Forgot Password?")],
                ),
                SizedBox(height: 25),
                // sign in button
                MyButton(onTap: login, text: "Login"),
                SizedBox(height: 25),
                // dont have an account? Register Here...
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont have an account?"),
                    GestureDetector(
                      onTap: onTap,
                      child: const Text(
                          style: TextStyle(fontWeight: FontWeight.bold),
                          " Register Here"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
