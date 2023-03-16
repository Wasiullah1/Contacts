import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/Models/currentappuser.dart';
import 'package:url_launcher/url_launcher.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({super.key});

  @override
  State<AddContacts> createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  @override
  Widget build(BuildContext context) {
    final uid = CurrentAppUser.currentUserData.uid;
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Contacts"),
        ),
        backgroundColor: Colors.blue.shade100,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('contacts')
                .doc(uid)
                .collection('contacts_added')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.size == 0) {
                return Center(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      FloatingActionButton(
                        // style: TextButton.styleFrom(
                        //   foregroundColor: Colors.blue,
                        // ),
                        onPressed: () async {
                          // Show dialog to add new contact
                          showDialog(
                            context: context,
                            builder: (context) {
                              String displayName = "";
                              String phoneNumber = "";
                              return AlertDialog(
                                title: Text("Add Contact"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      decoration:
                                          InputDecoration(labelText: "Name"),
                                      onChanged: (value) {
                                        displayName = value;
                                      },
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                          labelText: "Phone Number"),
                                      onChanged: (value) {
                                        phoneNumber = value;
                                      },
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Save"),
                                    onPressed: () async {
                                      // Save new contact to Firestore
                                      await FirebaseFirestore.instance
                                          .collection('contacts')
                                          .doc(uid)
                                          .collection('contacts_added')
                                          .add({
                                        "contact": [
                                          {
                                            "displayName": displayName,
                                            "phones": [
                                              {"value": phoneNumber}
                                            ]
                                          }
                                        ]
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Icon(Icons.add),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              } else {
                return Stack(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.size,
                            itemBuilder: (context, index) {
                              DocumentSnapshot cont =
                                  snapshot.data!.docs[index];
                              int count = index + 1;
                              return Card(
                                  child: ListTile(
                                leading: CircleAvatar(
                                    child: Text('$count'),
                                    backgroundColor:
                                        Color.fromRGBO(144, 164, 174, 1)),
                                title: Text(
                                    "${cont['contact'][0]['displayName']}"),
                                subtitle: Text(
                                    "${cont['contact'][0]['phones'][0]['value']}"),
                                trailing: IconButton(
                                  onPressed: () async {
                                    final Uri url = Uri(
                                        scheme: 'tel',
                                        path:
                                            "${cont['contact'][0]['phones'][0]['value']}");
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    } else {
                                      print("Can't launch this URL");
                                    }
                                  },
                                  icon: const Icon(Icons.phone),
                                ),
                              ));
                            }),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FloatingActionButton(
                          // style: TextButton.styleFrom(
                          //   foregroundColor: Colors.blue,
                          // ),
                          onPressed: () async {
                            // Show dialog to add new contact
                            showDialog(
                              context: context,
                              builder: (context) {
                                String displayName = "";
                                String phoneNumber = "";
                                return AlertDialog(
                                  title: Text("Add Contact"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        decoration:
                                            InputDecoration(labelText: "Name"),
                                        onChanged: (value) {
                                          displayName = value;
                                        },
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                            labelText: "Phone Number"),
                                        onChanged: (value) {
                                          phoneNumber = value;
                                        },
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Save"),
                                      onPressed: () async {
                                        // Save new contact to Firestore
                                        await FirebaseFirestore.instance
                                            .collection('contacts')
                                            .doc(uid)
                                            .collection('contacts_added')
                                            .add({
                                          "contact": [
                                            {
                                              "displayName": displayName,
                                              "phones": [
                                                {"value": phoneNumber}
                                              ]
                                            }
                                          ]
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(Icons.add),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ]);
              }
            }));
  }
}
