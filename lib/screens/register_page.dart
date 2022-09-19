import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/widget/show_nack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text_home_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});
  static String id = 'Register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? myEmail, password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
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
                      'REGISTER',
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
                    password = data;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                CustomButon(
                  text: 'Register',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await register();

                        Navigator.pushNamed(context, ChatPage.id,
                            arguments: myEmail);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          showSnackBar(
                              context, 'The password provided is too weak.',
                              color: Colors.red);
                        } else if (e.code == 'email-already-in-use') {
                          showSnackBar(context,
                              'The account already exists for that email.',
                              color: Colors.red);
                        }
                      } catch (e) {
                        showSnackBar(context, 'There is an error',
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
                      'Already have an account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '  Login',
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

  Future<void> register() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: myEmail!, password: password!);
  }
}
