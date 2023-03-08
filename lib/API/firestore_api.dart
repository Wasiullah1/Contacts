import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/Models/currentappuser.dart';
import 'package:contacts_service/contacts_service.dart';

class FirestoreApi {
  static Future uploadContacts(List<Contact> contacts) async {
    final uid = CurrentAppUser.currentUserData.uid ?? null;
    final contactsJSON = contacts.map((contacts) => contacts.toMap()).toList();

    final refUser = FirebaseFirestore.instance
        .collection('contacts')
        .doc(uid)
        .collection('contactlist');

    await refUser.add({
      'username': 'wasi',
      'contact': contactsJSON,
    });
  }
}
