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
              SizedBox(
                height: 10,
              ),
              Text("Customer Support",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Text(
                  'If you have any questions concerning the Keep Contacts Software Application, the Keep Contacts Service or this Agreement, please contact sync.com customer service by visiting sync.com'),
              SizedBox(
                height: 10,
              ),
              Text("Term and Termination",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Text(
                  'This Agreement will become effective in relation to you when you create an Keep Contacts account or when you start using the Keep Contacts Software Application or the Keep Contacts Service and will remain effective until terminated by you or Keep Contacts. Keep Contacts reserves the right to terminate this Agreement or suspend your Keep Contacts account at any time in case of unauthorised, or suspected unauthorised, use of the Keep Contacts Software Application or the Keep Contacts Service, whether in contravention of this Agreement or otherwise. If Keep Contacts terminates this Agreement, or suspends your Keep Contacts account for any of the reasons set out in this section, Keep Contacts shall have no liability or responsibility to you, and Keep Contacts will not refund any amounts that you have previously paid. We reserve the right to block usage from any country or market.'),
              SizedBox(
                height: 10,
              ),
              Text("No warranty",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Text(
                  'The use of the Keep Contacts Software Application and the Keep Contacts Service is at your own risk. The Keep Contacts Software Application and the Keep Contacts Service is provided on an "as is" and "as available" basis. To the fullest extent possible under applicable law, Keep Contacts gives no warranty, express or implied, as to the quality, content and availability or fitness for a specific purpose of the Keep Contacts Software Application or the Keep Contacts Service. In addition, Keep Contacts does not warrant, endorse, guarantee or assume responsibility for any product or service advertised or offered by a third party on or through the Keep Contacts Service or any hyperlinked website, or featured in any banner or other advertising.'),
            ],
          ),
        ),
      ),
    );
  }
}
