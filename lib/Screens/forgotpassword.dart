import 'package:contacts/Screens/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  bool load = false;
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue.shade100,
        body: Stack(children: [
          Positioned(
              top: 50,
              left: 10,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              )),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Forgot Password",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: Container(
                    height: 440.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Column(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SvgPicture.asset(
                              'assets/logo-keep.svg',
                              height: 50,
                              width: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Form(
                              key: _formkey,
                              child: Column(children: [
                                TextFormField(
                                  controller: emailController,
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: InkWell(
                                      onTap: () async {
                                        if (_formkey.currentState!.validate()) {
                                          setState(() {
                                            load = false;
                                          });
                                          try {
                                            _auth
                                                .sendPasswordResetEmail(
                                                    email: emailController.text
                                                        .toString())
                                                .then((value) {
                                              setState(() {
                                                load = false;
                                              });
                                              toastMessage(
                                                  'Please Check your email, a reset link has been sent to your email');
                                            }).onError((error, stackTrace) {
                                              toastMessage(error.toString());
                                              setState(() {
                                                load = false;
                                              });
                                            });
                                          } catch (e) {
                                            print(e.toString());
                                            toastMessage(e.toString());
                                          }
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen()));
                                        }
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
                                                Center(child: Text("Register")),
                                          ))),
                                ),
                              ]),
                            ),
                          )
                        ]))))
          ]),
        ]));
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
