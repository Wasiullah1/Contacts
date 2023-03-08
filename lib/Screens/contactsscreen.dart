import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/API/firestore_api.dart';
//import 'package:contacts/API/firestore_api.dart';
import 'package:contacts/Models/currentappuser.dart';
import 'package:contacts/Screens/homescreen.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = CurrentAppUser.currentUserData.uid;
    return Scaffold(
        backgroundColor: Colors.blue.shade100,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('contacts')
                .doc(uid)
                .collection('contactlist')
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.data!.size == 0) {
                  return Stack(children: [
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
                    Text("There is no data"),
                  ]);
                } else {
                  return Stack(children: [
                    Positioned(
                        top: 30,
                        left: 10,
                        child: IconButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen())),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        )),
                    SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SingleChildScrollView(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data?.size,
                                    itemBuilder: (context, index) {
                                      QueryDocumentSnapshot contacts =
                                          snapshot.data!.docs[index];
                                      return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${contacts['contact'][0]['displayName']}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ])));
                                    }))
                          ]),
                    ))
                  ]);
                }
              }
            }));
  }
}
