// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:talli_fitness/Components/my_button.dart';
import '/Components/my_textfield.dart';

// -----------------------------------------------------------------------------------
//                   Tutorial used to create Authentication Page
//                   https://www.youtube.com/watch?v=0RWLaJxW7Oc
// -----------------------------------------------------------------------------------

class Registerpage extends StatelessWidget {
  final void Function()? onTap;

  Registerpage({
    super.key,
    required this.onTap,
  });

  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwdController = TextEditingController();

  void register() {}

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
                // Name Text Field
                MyTextfield(
                    hintText: "Name",
                    obscureText: false,
                    controller: nameController),
                SizedBox(height: 10),
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

                // Confirm Password
                MyTextfield(
                    hintText: "Confirm Password",
                    obscureText: true,
                    controller: confirmPwdController),
                SizedBox(height: 10),

                SizedBox(height: 25),

                // register button
                MyButton(onTap: register, text: "Register"),
                SizedBox(height: 25),

                // already have an account? Register Here...
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    GestureDetector(
                      onTap: onTap,
                      child: const Text(
                          style: TextStyle(fontWeight: FontWeight.bold),
                          " Login Here"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
