import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/Models/appuser.dart';
import 'package:contacts/Screens/loginscreen.dart';
import 'package:contacts/Screens/terms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  static const String id = '/signup';
  String username = "", email = "", password = "", contact = "";
  bool load = false;
  bool showSpinner = false;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController contactcontroller = TextEditingController();

  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue.shade200,
          ),
          backgroundColor: Colors.lightBlue.shade100,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Signup",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 56, vertical: 20),
                        child: Container(
                          height: 440.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(color: Colors.blueAccent),
                            color: Colors.white,
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: Column(children: <Widget>[
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.symmetric(vertical: 10),
                              //   child: SvgPicture.asset(
                              //     'assets/logo-keep.svg',
                              //     height: 50,
                              //     width: 50,
                              //   ),
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: namecontroller,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'required';
                                          } else
                                            return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person),
                                          hintText: 'Username',
                                          labelText: 'Username',
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  20.0, 10.0, 20.0, 10.0),
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller: emailcontroller,
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  20.0, 10.0, 20.0, 10.0),
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                          prefixIcon: Icon(Icons.lock),
                                          hintText: 'Password',
                                          labelText: 'Password',
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  20.0, 10.0, 20.0, 10.0),
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller: contactcontroller,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'required';
                                          } else
                                            return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.phone),
                                          hintText: 'Contact',
                                          labelText: 'Contact',
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  20.0, 10.0, 20.0, 10.0),
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: InkWell(
                                            onTap: () async {
                                              await signUp(
                                                  emailcontroller.text
                                                      .toString(),
                                                  passwordcontroller.text
                                                      .toString());
                                            },
                                            child: Container(
                                                height: 40,
                                                width: 250,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(),
                                                    color: Color.fromARGB(
                                                        255, 143, 239, 148)),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 30),
                                                  child: Center(
                                                      child: Text("Register")),
                                                ))),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          "By clicking the Register account button above you agree on our"),
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const TermsofService()));
                                          },
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Terms of Service.",
                                              style: TextStyle(
                                                  color: Colors.lightGreen),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ))
                  ]),
            ),
          )),
    );
  }

  Future<void> signUp(String email, String password) async {
    print('111 ${emailcontroller.text}');
    print('111 ${namecontroller.text}');
    print('111 ${passwordcontroller.text}');
    print('111 ${contactcontroller.text}');
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
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

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    AppUser userModel = AppUser();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = namecontroller.text;
    userModel.phone = contactcontroller.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(AppUser.toMap(userModel));
    Fluttertoast.showToast(msg: "Account created successfully");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
