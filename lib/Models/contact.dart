class Contact {
  final String name;
  final String phoneNumber;

  Contact({required this.name, required this.phoneNumber});

  Contact.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        phoneNumber = map['phoneNumber'];

  Map<String, dynamic> toMap() => {'name': name, 'phoneNumber': phoneNumber};
}