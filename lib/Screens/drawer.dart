import 'package:contacts/Models/currentappuser.dart';
import 'package:contacts/Screens/contactsscreen.dart';
import 'package:contacts/Screens/loginscreen.dart';
import 'package:contacts/Screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? name;
  String? email;

  // final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    name = CurrentAppUser.currentUserData.name ?? "";
    email = CurrentAppUser.currentUserData.email ?? "";
    setState(() {});
  }

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return _buildDrawer();
  }

  _buildDrawer() {
    final String image = CurrentAppUser.currentUserData.image ?? "";
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 40),
      decoration: BoxDecoration(
          color: Colors.white, boxShadow: [BoxShadow(color: Colors.black45)]),
      width: 300,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
              height: 90,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage("$image"),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "$name",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "$email",
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
            SizedBox(height: 30.0),
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: _buildRow(Icons.home, "Home")),
            SizedBox(height: 20.0),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactsScreen()));
                },
                child: _buildRow(Icons.contacts, "Contacts")),
            SizedBox(height: 20.0),
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Settings()));
                },
                child: _buildRow(Icons.settings, "Setting")),
            SizedBox(height: 20.0),
            InkWell(
                onTap: () async {
                  await logout(context);
                },
                child: _buildRow(Icons.logout, "Logout")),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String title, {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(color: Colors.grey, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(children: [
        Icon(
          icon,
          color: Colors.grey,
        ),
        SizedBox(width: 10.0),
        Text(
          title,
          style: tStyle,
        ),
        Spacer(),
      ]),
    );
  }
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => LoginScreen()));
}
