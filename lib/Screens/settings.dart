import 'dart:developer';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/Models/currentappuser.dart';
import 'package:contacts/Screens/home.dart';
import 'package:contacts/Screens/loginscreen.dart';
import 'package:contacts/Screens/terms.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _contactsPermissionGranted = false;
  bool _autoSyncContacts = false;
  String? name;
  String? email;
  @override
  void initState() {
    super.initState();
    name = CurrentAppUser.currentUserData.name ?? "";
    email = CurrentAppUser.currentUserData.email ?? "";
    setState(() {});
    _loadAutoSyncContacts();
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

  Future<void> _loadAutoSyncContacts() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .get();

    setState(() {
      _autoSyncContacts =
          documentSnapshot.data()?['auto_sync_contacts'] ?? false;
    });
  }

  final uid = CurrentAppUser.currentUserData.uid;
  Future<void> _saveAutoSyncContacts(bool value) async {
    //final User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('contacts')
        .doc(uid)
        .update({'auto_sync_contacts': value});
  }

  Future<void> _checkContactsPermission() async {
    final PermissionStatus permissionStatus =
        await Permission.contacts.request();

    setState(() {
      _contactsPermissionGranted = permissionStatus == PermissionStatus.granted;
    });

    if (_autoSyncContacts && _contactsPermissionGranted) {
      // Automatically sync the contacts if the switch is enabled and the permission is granted
      await _syncContacts();
    }
  }

  Future<void> _syncContacts() async {
    final Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);

    //final User? user = FirebaseAuth.instance.currentUser;
    final CollectionReference contactsRef =
        FirebaseFirestore.instance.collection('contacts');

    for (final Contact contact in contacts) {
      // Check if the contact has already been synced
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await contactsRef
              .doc(uid)
              .collection('user_contacts')
              .where('phone', isEqualTo: contact.phones?.first.value)
              .get();

      if (querySnapshot.docs.isEmpty) {
        // Contact not found, add it to the collection
        await contactsRef.doc(uid).collection('user_contacts').add({
          'name': contact.displayName ?? '',
          'phone': contact.phones?.first.value ?? '',
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var _itemHeader = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 16.0,
    );
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade300,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20.0),
          Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  //avatar
                  Badge(
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
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator());
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
                      )),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ListTile(
            title: Text(
              "Username: ${name?.toUpperCase()}",
            ),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text(
              "Email: $email",
            ),
            leading: Icon(Icons.email),
          ),
          _buildDivider(),
          ListTile(
            title: Text(
              "Contacts",
            ),
            leading: Icon(Icons.contact_phone),
          ),
          SwitchListTile(
            value: _autoSyncContacts,
            title: Center(child: Text("Auto Sync Contacts")),
            onChanged: (bool value) async {
              setState(() {
                _autoSyncContacts = value;
              });
              await _saveAutoSyncContacts(value);
              if (value) {
                if (_contactsPermissionGranted) {
                  // Automatically sync the contacts if the switch is enabled and the permission is granted
                  await _syncContacts();
                } else {
                  // If the permission is not granted, request it
                  final PermissionStatus permissionStatus =
                      await Permission.contacts.request();

                  setState(() {
                    _contactsPermissionGranted =
                        permissionStatus == PermissionStatus.granted;
                  });

                  if (_contactsPermissionGranted) {
                    // Sync contacts if permission is granted after requesting it
                    await _syncContacts();
                  }
                }
              }
            },
          ),
          _buildDivider(),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TermsofService()));
            },
            child: ListTile(
              title: Text("Terms & Conditions"),
              subtitle: Text("legal, terms and conditions"),
              leading: Icon(Icons.feedback),
            ),
          ),
          _buildDivider(),
          InkWell(
            onTap: () async {
              await logout(context);
            },
            child: ListTile(
              title: Text("Logout"),
              subtitle: Text("you can logout from here"),
              leading: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 70),
      child: Divider(
        color: Colors.black,
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
