import 'package:contacts/Models/currentappuser.dart';
import 'package:contacts/Screens/forgotpassword.dart';
import 'package:contacts/Screens/homescreen.dart';
import 'package:contacts/Screens/loginscreenview.dart';
import 'package:contacts/Screens/signupscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = "", email = "", password = "", contact = "";
  bool load = false;
  bool showSpinner = false;

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Image.asset(
                'assets/backgroun.png',
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  child: Container(
                    height: 445.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 15.0),
                      child: Column(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: SvgPicture.asset(
                            'assets/logo-keep.svg',
                            height: 50,
                            width: 50,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Keep Contacts is the best way to manage, sync and backup your phone´s address book - it works on basically any device imaginable.",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupScreen()));
                            },
                            child: const Text("Register New Account",
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 11)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(),
                                    color: Colors.white),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Image.asset(
                                        'assets/icon-google-signin.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                    const Text("Signin with Google")
                                  ],
                                )),
                          ),
                        ),
                        _buildDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: emailcontroller,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'required';
                                    } else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email),
                                    hintText: 'Emai',
                                    labelText: 'Email',
                                    filled: true,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: passwordcontroller,
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'required';
                                    } else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    hintText: 'Password',
                                    labelText: 'Password',
                                    filled: true,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ForgotPassword()));
                                    },
                                    child: const Text("Forgot Password",
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 11)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: InkWell(
                                      onTap: () async {
                                        await signIn(emailcontroller.text,
                                            passwordcontroller.text);
                                      },
                                      child: Container(
                                          height: 40,
                                          width: 250,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(),
                                              color: Color.fromARGB(
                                                  255, 143, 239, 148)),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 30),
                                            child:
                                                Center(child: Text("Signin")),
                                          ))),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ))
            ]),
            const Description1(),
            const Description2(),
            const Description3(),
            const Description4(),
            const Footer(),
            //
          ],
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: Colors.grey.shade400,
    );
  }

  Future<void> signIn(String email, String password) async {
    print("Validated");

    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                CurrentAppUser.currentUserData
                    .getCurrentUserData(uid.user!.uid),
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen())),
              });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";

          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
      print(error.code);
    }
  }
}
