import 'package:contacts/API/firestore_api.dart';
import 'package:contacts/Models/currentappuser.dart';
import 'package:contacts/Screens/drawer.dart';
import 'package:contacts/Screens/loginscreen.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contacts/Utils/contacts_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uid = CurrentAppUser.currentUserData.uid;
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? name;
  String? email;

  final user = FirebaseAuth.instance.currentUser!;

  bool showSpinner = false;
  @override
  void initState() {
    super.initState();
    name = CurrentAppUser.currentUserData.name ?? "";
    email = CurrentAppUser.currentUserData.email ?? "";
    setState(() {});
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

  void goToHomePage() async {
    await logout(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final String image = CurrentAppUser.currentUserData.image ?? "";
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Spacer(),
            Column(
              children: [
                Container(
                  height: 180,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: NetworkImage("$image"),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "$name",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10.0),
                Text(
                  "$email",
                  style: TextStyle(color: Colors.black, fontSize: 25.0),
                ),
              ],
            ),

            SizedBox(
              height: 36,
            ),
            InkWell(
                onTap: () {
                  askContactsPermission();
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
                          "Upload Contacts",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))),
            SizedBox(
              height: 20,
            ),
            // InkWell(
            //     onTap: () {
            //       goToHomePage();
            //     },
            //     child: Container(
            //         height: 40,
            //         width: 140,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(20),
            //             color: Colors.blue),
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Text(
            //             "Continue",
            //             style: TextStyle(color: Colors.white),
            //           ),
            //         ))),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
