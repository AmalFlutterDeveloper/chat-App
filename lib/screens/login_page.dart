import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/screens/register_page.dart';
import 'package:chat_app/widget/custom_button.dart';
import 'package:chat_app/widget/show_nack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widget/custom_text_home_field.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  static String id = 'Login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? myEmail, myPassword;
  bool isLoading = false;
  GlobalKey<FormState> keyForm = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: keyForm,
            child: ListView(
              children: [
                SizedBox(
                  height: 100,
                ),
                Image.asset(
                  'assets/images/scholar.png',
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Scholar chat',
                      style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'Pacifico',
                          color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(
                  height: 75,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LOGIN',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextHomeField(
                  hintText: 'Email',
                  onChanged: (data) {
                    myEmail = data;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextHomeField(
                  obscureText: true,
                  hintText: 'Password',
                  onChanged: (data) {
                    myPassword = data;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                CustomButon(
                  text: 'LOGIN',
                  onTap: () async {
                    if (keyForm.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await signIn();
                        Navigator.pushNamed(context, ChatPage.id,
                            arguments: myEmail);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showSnackBar(context, 'No user found for that email.',
                              color: Colors.red);
                        } else if (e.code == 'wrong-password') {
                          showSnackBar(
                              context, 'Wrong password provided for that user.',
                              color: Colors.red);
                        }
                      } catch (e) {
                        showSnackBar(context, 'There is an error.',
                            color: Colors.red);
                      }
                      isLoading = false;
                      setState(() {});
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'don\'t have an account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, RegisterPage.id),
                      child: const Text(
                        '  Register',
                        style: TextStyle(color: Color(0xffC7EDE6)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: myEmail!, password: myPassword!);
  }
}
