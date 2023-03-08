import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Description1 extends StatelessWidget {
  const Description1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          Image.asset(
            "assets/login-image-addressbook.png",
            height: 140,
            width: 140,
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Your address book \neverywhere",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Install Keep Contacts on all your \ndevices to keep your address book up\n-to-date and in sync on all of them.",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Description2 extends StatelessWidget {
  const Description2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Editing contacts \nis incredibly easy!",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Use our web interface to edit,\ndelete, add and merge your contacts.\nYour changes will automatically\nupdate the address book in\nyour devices!",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Image.asset(
            "assets/login-image-editing.png",
            height: 140,
            width: 140,
          ),
        ],
      ),
    );
  }
}

class Description3 extends StatelessWidget {
  const Description3({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          Image.asset(
            "assets/login-image-addressbook.png",
            height: 140,
            width: 140,
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Let´s Keep it nice \nand tidy...",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Easily merge duplicates in your \ncontact list in order to keep your \ncontact list all cleaned up.",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Description4 extends StatelessWidget {
  const Description4({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Editing contacts \nis incredibly easy!",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Use our web interface to edit, \ndelete, add and merge your contacts.\nYour changes will automatically\nupdate the address book in \nyour devices!",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SvgPicture.asset(
            "assets/login-image-losephone.svg",
            height: 140,
            width: 140,
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900,
      ),
    );
  }
}
