// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/Components/my_button.dart';
import '/HelperFunctions/helper_functions.dart';
import '/Components/my_textfield.dart';

// -----------------------------------------------------------------------------------
//                   Tutorial used to create Authentication Page
//                   https://www.youtube.com/watch?v=0RWLaJxW7Oc
// -----------------------------------------------------------------------------------

class Registerpage extends StatefulWidget {
  final void Function()? onTap;

  const Registerpage({
    super.key,
    required this.onTap,
  });

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwdController = TextEditingController();

  Future<void> registerUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // make sure passwords match
    if (passwordController.text != confirmPwdController.text) {
      // pop loading circle
      Navigator.pop(context);

      // shpw error messahe to user
      //TODO I wonder if you could use a final formKey = GlobalKey<FormState>(); for validating
      displayMessageToUser("Passwords don't match!", context);
    } else {
      // try creating the user
      try {
        // create user
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // pop loading circle
        // TODO this caused an issue, removing for now but will come back to review
        // Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop loading circle
        Navigator.pop(context);

        // display error message to the user
        displayMessageToUser(e.code, context);
      }
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
                MyButton(onTap: registerUser, text: "Register"),
                SizedBox(height: 25),

                // already have an account? Register Here...
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    GestureDetector(
                      onTap: widget.onTap,
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
