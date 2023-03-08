import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Contacts {
  final String id;
  final String? name;
  final String? city;

  final String? contact;

  Contacts({
    required this.id,
    required this.name,
    required this.city,
    required this.contact,
  });

  static Contacts fromMap(Map data) {
    return Contacts(
      id: data['uid'],
      name: data['name'],
      city: data['city'],
      contact: data['phone'],
    );
  }
}
