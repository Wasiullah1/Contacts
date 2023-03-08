import 'package:contacts/API/firestore_api.dart';
import 'package:contacts/Models/currentappuser.dart';
import 'package:contacts/Screens/drawer.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:contacts/Utils/contacts_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uid = CurrentAppUser.currentUserData.uid ?? null;
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    super.initState();

    askContactsPermission();
  }

  Future askContactsPermission() async {
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
  }

  Future uploadContacts() async {
    final contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();

    await FirestoreApi.uploadContacts(contacts);
  }

  void goToHomePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Sync")),
      drawer: MyDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
        ),
        child: Column(
          children: [
            Text(
              "Enable App Permission to upload contacts",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
            InkWell(
                onTap: () {
                  askContactsPermission();
                },
                child: Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Upload Contacts",
                        style: TextStyle(color: Colors.white),
                      ),
                    ))),
            SizedBox(
              height: 10,
            ),
            InkWell(
                onTap: () {
                  goToHomePage();
                },
                child: Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
