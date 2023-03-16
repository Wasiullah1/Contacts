import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:contacts/Models/currentappuser.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactScreen extends StatefulWidget {
  final String uid;

  ContactScreen({required this.uid});

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  Future<void> _addContact() async {
    await FirebaseFirestore.instance
        .collection('contacts')
        .doc(user?.uid)
        .collection('user_contacts')
        .add({
      'name': _nameController.text,
      'phone': _phoneNumberController.text,
    });

    _nameController.clear();
    _phoneNumberController.clear();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('contacts')
              .doc(user?.uid)
              .collection('user_contacts')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                  child: Text(
                'No contacts found',
                style: TextStyle(fontWeight: FontWeight.bold),
              ));
            }

            return Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> data = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        int count = index + 1;
                        if (_searchText.isEmpty ||
                            data['name'].toLowerCase().contains(_searchText)) {
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text('$count'),
                              backgroundColor: Colors.grey,
                            ),
                            title: Text(data['name']),
                            subtitle: Text(data['phone']),
                            trailing: IconButton(
                              onPressed: () async {
                                final Uri url = Uri(
                                    scheme: 'tel', path: "${data['phone']}");
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  print("Can't launch this URL");
                                }
                              },
                              icon: const Icon(Icons.phone),
                            ),
                          );
                        }
                        return Container();
                      }))
            ]);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Contact'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Name',
                      ),
                    ),
                    TextField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addContact();
                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// class ContactsScreen extends StatefulWidget {
//   const ContactsScreen({super.key});

//   @override
//   State<ContactsScreen> createState() => _ContactsScreenState();
// }

// class _ContactsScreenState extends State<ContactsScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List myContacts = [];
//     List myContactsnum = [];
//     final uid = CurrentAppUser.currentUserData.uid;
//     return Scaffold(
//       appBar: AppBar(title: Text("Contacts Screen")),
//       backgroundColor: Colors.blue.shade100,
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('contacts')
//             .doc(uid)
//             .collection('contactlist')
//             .snapshots()
//           ..listen((QuerySnapshot snapshot) {
//             for (var document in snapshot.docs) {
//               Map<String, dynamic> data =
//                   document.data() as Map<String, dynamic>;
//               for (int i = 0; i < data["contact"].length; i++) {
//                 print(data['contact'][i]['displayName']);
//                 myContacts.add(data['contact'][i]);
//               }
//               return;
//             }
//           }),
//         builder: (context, AsyncSnapshot snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             if (snapshot.data!.size == 0) {
//               return Stack(children: [
//                 Positioned(
//                     top: 50,
//                     left: 10,
//                     child: IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(
//                         Icons.arrow_back_ios,
//                         color: Colors.white,
//                       ),
//                     )),
//                 Center(
//                     child: Text(
//                   "There is no data",
//                   style: TextStyle(fontSize: 15, color: Colors.red),
//                 )),
//               ]);
//             } else {
//               return ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: myContacts.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: ListTile(
//                       leading: CircleAvatar(
//                           backgroundColor: Colors.blueGrey.shade300),
//                       title: Text("${myContacts[index]["displayName"]}"),
//                       subtitle:
//                           Text("${myContacts[index]["phones"][0]['value']}"),
//                       trailing: IconButton(
//                         onPressed: () async {
//                           final Uri url = Uri(
//                               scheme: 'tel',
//                               path:
//                                   "${myContacts[index]["phones"][0]['value']}");
//                           if (await canLaunchUrl(url)) {
//                             await launchUrl(url);
//                           } else {
//                             print("Can't launch this URL");
//                           }
//                         },
//                         icon: const Icon(Icons.phone),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           }
//         },
//       ),
//     );
//   }
// }
