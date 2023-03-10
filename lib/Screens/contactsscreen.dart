import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:contacts/API/firestore_api.dart';
import 'package:contacts/Models/currentappuser.dart';
import 'package:contacts/Utils/auth_services.dart';

import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    List myContacts = [];
    final uid = CurrentAppUser.currentUserData.uid;
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('contacts')
            .doc(uid)
            .collection('contactlist')
            .snapshots()
          ..listen((QuerySnapshot snapshot) {
            for (var document in snapshot.docs) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              for (int i = 0; i < data["contact"].length; i++) {
                print(data['contact'][i]['displayName']);
                myContacts.add(data['contact'][i]);
              }
              return;
            }
          }),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
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
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    )),
                Center(child: Text("There is no data")),
              ]);
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: myContacts.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text("${myContacts[index]["displayName"]}"),
                      trailing: IconButton(
                        onPressed: () {
                          // FirestoreApi.deleteContact(
                          //     contacts['contactName']);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  );
                },
              );
              // return Stack(children: [
              //   Positioned(
              //       top: 30,
              //       left: 10,
              //       child: IconButton(
              //         onPressed: () => Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => HomeScreen())),
              //         icon: const Icon(
              //           Icons.arrow_back_ios,
              //           color: Colors.white,
              //         ),
              //       )),
              //   SingleChildScrollView(
              //       child: Padding(
              //     padding: const EdgeInsets.symmetric(
              //         horizontal: 20, vertical: 20),
              //     child: Column(
              //         // mainAxisAlignment: MainAxisAlignment.center,
              //         // crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           SingleChildScrollView(
              //             child:
              //           )
              //         ]),
              //   ))
              // ]);
            }
          }
        },
      ),
    );
  }
}
