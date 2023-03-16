import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/API/firestore_api.dart';
import 'package:contacts/Models/currentappuser.dart';
import 'package:contacts/Screens/contactScreen.dart';
import 'package:contacts/Screens/drawer.dart';
import 'package:contacts/Screens/loginscreen.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:contacts/Utils/contacts_utils.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isContactsUploaded = false;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    askContactsPermission();
  }

  Future<void> askContactsPermission() async {
    final permission = await ContactUtils.getContactPermission();

    switch (permission) {
      case PermissionStatus.granted:
        uploadContacts();
        break;

      case PermissionStatus.permanentlyDenied:
        goToHomePage();
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.white,
          content: Text('Please allow to "Upload Contacts'),
          duration: Duration(seconds: 3),
        ));
        break;
    }
    setState(() {
      isContactsUploaded = true;
    });
  }

  Future<void> uploadContacts() async {
    if (isContactsUploaded) return; // added

    final contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();

    await FirestoreApi.uploadContacts(contacts);

    setState(() {
      isContactsUploaded = true; // added
    });
  }

  void goToHomePage() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Sync")),
        drawer: MyDrawer(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
          ),
          child: Column(
            children: [
              Spacer(),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactsScreen()));
                  },
                  child: Container(
                      height: 40,
                      width: 240,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Contacts Screen",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ))),
              SizedBox(
                height: 30,
              )
            ],
          ),
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     InkWell(
          //         onTap: () {
          //           askContactsPermission();
          //         },
          //         child: Container(
          //             height: 40,
          //             width: 240,
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(10),
          //                 color: Colors.blue),
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Center(
          //                 child: Text(
          //                   "Upload Contacts",
          //                   style: TextStyle(
          //                       color: Colors.white, fontWeight: FontWeight.bold),
          //                 ),
          //               ),
          //             ))),
          //     SizedBox(
          //       height: 20,
          //     ),
          //     InkWell(
          //         onTap: () {
          //           uploadContacts();
          //         },
          //         child: Container(
          //             height: 40,
          //             width: 240,
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(10),
          //                 color: Colors.blue),
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Center(
          //                 child: Text(
          //                   "Upload Contacts",
          //                   style: TextStyle(
          //                       color: Colors.white, fontWeight: FontWeight.bold),
          //                 ),
          //               ),
          //             ))),
          //   ],
          // ),
        ),
      ),
    );
  }
}
