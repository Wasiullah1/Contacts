import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/Models/currentappuser.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// class ContactScreen extends StatefulWidget {
//   const ContactScreen({Key? key}) : super(key: key);

//   @override
//   _ContactScreenState createState() => _ContactScreenState();
// }

// class _ContactScreenState extends State<ContactScreen> {
//   List<Contact> _contacts = [];

//   @override
//   void initState() {
//     super.initState();
//     _getContacts();
//   }

//   Future<void> _getContacts() async {
//     final contacts = await ContactsService.getContacts();
//     setState(() {
//       _contacts = contacts.toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Contacts')),
//       body: ListView.builder(
//         itemCount: _contacts.length,
//         itemBuilder: (BuildContext context, int index) {
//           final contact = _contacts[index];
//           return ListTile(
//             title: Text(contact.displayName ?? ''),
//             subtitle: Text(contact.phones?.first.value ?? ''),
//             leading: CircleAvatar(
//               child: Text(contact.initials()),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List myContacts = [];
    List myContactsnum = [];
    final uid = CurrentAppUser.currentUserData.uid;
    return Scaffold(
      appBar: AppBar(title: Text("Contacts Screen")),
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
                // Positioned(
                //     top: 50,
                //     left: 10,
                //     child: IconButton(
                //       onPressed: () => Navigator.pop(context),
                //       icon: const Icon(
                //         Icons.arrow_back_ios,
                //         color: Colors.white,
                //       ),
                //     )),
                Center(
                    child: Text(
                  "There is no data",
                  style: TextStyle(fontSize: 15, color: Colors.red),
                )),
              ]);
            } else {
              return Column(children: [
                Expanded(
                    child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: myContacts.length,
                  itemBuilder: (context, index) {
                    int count = index + 1;
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                            child: Text('$count'),
                            backgroundColor: Color.fromRGBO(144, 164, 174, 1)),
                        title: Text("${myContacts[index]["displayName"]}"),
                        subtitle: (myContacts[index]["phones"] != null)
                            ? Text("${myContacts[index]["phones"][0]['value']}")
                            : Text(
                                "${myContacts[index]["emails"][0]['value']}"),
                        trailing: IconButton(
                          onPressed: () async {
                            final Uri url = Uri(
                                scheme: 'tel',
                                path:
                                    "${myContacts[index]["phones"][0]['value']}");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              print("Can't launch this URL");
                            }
                          },
                          icon: const Icon(Icons.phone),
                        ),
                      ),
                    );
                  },
                )),
              ]);
            }
          }
        },
      ),
    );
  }
}
