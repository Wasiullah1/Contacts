import 'package:flutter/material.dart';

class TermsofService extends StatefulWidget {
  const TermsofService({super.key});

  @override
  State<TermsofService> createState() => _TermsofServiceState();
}

class _TermsofServiceState extends State<TermsofService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Terms of Services")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Terms and Conditions of Use",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'These General Terms and Conditions of Use (the "Agreement") shall apply when Tactel AB provides a service named Keep Contacts (the "Service") to a consumer (the "Customer").'),
              SizedBox(
                height: 10,
              ),
              Text("Contract Formation",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Text(
                  'By creating a Keep Contacts account or by using the Keep Contacts Software Application or the Keep Contacts Service, you accept and confirm that any registration information that you submit to Keep Contacts is true, accurate and complete, that you will update such information in order to keep it current, and that you agree to the terms and conditions of this Agreement.'),
            ],
          ),
        ),
      ),
    );
  }
}
