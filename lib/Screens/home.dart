import 'dart:io';

import 'package:contacts/Screens/drawer.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late bool _contactsPermissionGranted;
  late List<Contact> _contactsList;

  @override
  void initState() {
    super.initState();

    _contactsPermissionGranted = false;
    _contactsList = [];

    _checkContactsPermission();
  }

  Future<void> _checkContactsPermission() async {
    final PermissionStatus permissionStatus =
        await Permission.contacts.request();

    setState(() {
      _contactsPermissionGranted = permissionStatus == PermissionStatus.granted;
    });
  }

  Future<void> _getContacts() async {
    final Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);

    setState(() {
      _contactsList = contacts.toList();
    });

    final User? user = FirebaseAuth.instance.currentUser;
    final CollectionReference contactsRef =
        FirebaseFirestore.instance.collection('contacts');

    final List<String> syncedPhoneNumbers = [];

    for (final Contact contact in _contactsList) {
      final String? phoneNumber = contact.phones?.first.value;

      if (phoneNumber != null && !syncedPhoneNumbers.contains(phoneNumber)) {
        // Check if the contact has already been synced
        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await contactsRef
                .doc(user?.uid)
                .collection('user_contacts')
                .doc(contact.hashCode.toString())
                .get();

        if (!documentSnapshot.exists) {
          await contactsRef
              .doc(user?.uid)
              .collection('user_contacts')
              .doc(contact.hashCode.toString())
              .set({
            'name': contact.displayName ?? '',
            'phone': phoneNumber,
          });

          syncedPhoneNumbers.add(phoneNumber);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sync Contacts'),
        ),
        drawer: MyDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_contactsPermissionGranted)
                InkWell(
                  onTap: _getContacts,
                  child: Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue),
                      child: Center(
                          child: Text(
                        'Sync Contacts',
                        style: TextStyle(color: Colors.white),
                      ))),
                )
              else
                InkWell(
                  onTap: _checkContactsPermission,
                  child: Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue),
                      child: Center(
                        child: Text(
                          'Grant Contacts Permission',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
