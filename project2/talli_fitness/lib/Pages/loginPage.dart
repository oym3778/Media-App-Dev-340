// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talli_fitness/HelperFunctions/helper_functions.dart';
import '/Components/my_button.dart';
import '/Components/my_textfield.dart';

// -----------------------------------------------------------------------------------
//                   Tutorial used to create Authentication Page
//                   https://www.youtube.com/watch?v=0RWLaJxW7Oc
// -----------------------------------------------------------------------------------

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void forgotPassword(){
    //TODO implement forgot password
  }

  void login() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
      ),
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // pop loading circle
      Navigator.pop(context);

    }
    // display any errors
    on FirebaseAuthException catch (e) {
        // pop loading circle
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(224, 242, 241, 1),
        // appBar: AppBar(
        //   title: const Text("Tali Fitness"),
        //   centerTitle: true,
        //   backgroundColor: Colors.teal.shade200,
        // ),
        body: SizedBox(
          child: Padding(
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
          
                  // // forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: /*forgotPassword*/ () {
                          displayMessageToUser("Not yet implemented, please register a new account", context);
                        },
                        child: Text("Forgot Password?"),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  // sign in button
                  MyButton(onTap: login, text: "Login"),
                  SizedBox(height: 25),
                  // dont have an account? Register Here...
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Dont have an account?"),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            " Register Here"),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
