import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/Models/currentappuser.dart';
import 'package:contacts/Screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? name1;
  String? name;
  String? email;
  @override
  void initState() {
    super.initState();
    name = CurrentAppUser.currentUserData.name ?? "";
    email = CurrentAppUser.currentUserData.email ?? "";
    setState(() {});
  }

  bool showSpinner = false;
  final ref = FirebaseStorage.instance.ref('images');
  bool isUploading = false;

  void uploadImage() {
    setState(() {
      isUploading = true;
    });
    final _auth = FirebaseAuth.instance;
    final _user = _auth.currentUser;
    if (_user != null && _image != null) {
      final _uid = _user.uid;
      final imageExt = _image!.path.split('.').last;
      final _ref = FirebaseStorage.instance.ref('images/$_uid.$imageExt');
      _ref.putFile(_image!).then((value) {
        value.ref.getDownloadURL().then((value) async {
          print(value);
          Fluttertoast.showToast(msg: "Image Uploaded");
          var _ref = FirebaseFirestore.instance.collection('users');
          if ((await _ref.doc(_uid).get()).exists) {
            await _ref.doc('$_uid').update({'image': value});
          }
          setState(() {
            isUploading = false;
          });
        });
      });
    }
  }

  File? _image;
  final picker = ImagePicker();
  Future getCameraImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadImage();
      } else {
        print("No Image Selected");
      }
    });
  }

  Future getGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadImage();
      } else {
        print("No Image Selected");
      }
    });
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                      onTap: () {
                        getCameraImage();
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text("Camera"),
                      )),
                  InkWell(
                      onTap: () {
                        getGalleryImage();
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text("Gallery"),
                      ))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade100,
        body: SafeArea(
          child: Stack(children: [
            Positioned(
                top: 50,
                left: 10,
                child: IconButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen())),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Badge(
                    badgeColor: Colors.white70,
                    position: BadgePosition.bottomEnd(),
                    badgeContent: InkWell(
                      onTap: () => dialog(context),
                      child: isUploading
                          ? CircularProgressIndicator()
                          : Icon(
                              Icons.camera_alt,
                              // color: Colors.grey.shade500,
                              size: 30.0,
                            ),
                    ),
                    child: Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 5)),
                      child: ClipOval(
                        // borderRadius: BorderRadius.circular(100),
                        child: Image(
                            image: NetworkImage(
                              CurrentAppUser.currentUserData.image ??
                                  "https://firebasestorage.googleapis.com/v0/b/cardoctor-1f2c7.appspot.com/o/images%2Fdefault.png?alt=media&token=0b0b0b0b-0b0b-0b0b-0b0b-0b0b0b0b0b0b",
                            ),
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                              );
                            }),
                      ),
                    ),
                  )),
                  SizedBox(height: 20),
                  Text(
                    " $name",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Pacifico',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "$email",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Pacifico',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Text(
                  //   "$email".toUpperCase(),
                  //   style: TextStyle(
                  //     fontSize: 20.0,
                  //     fontFamily: 'SourceSansPro',
                  //     color: Colors.teal.shade100,
                  //     fontWeight: FontWeight.bold,
                  //     letterSpacing: 2.5,
                  //   ),
                  // ),
                ],
              ),
            ),
          ]),
        ));
  }
}
