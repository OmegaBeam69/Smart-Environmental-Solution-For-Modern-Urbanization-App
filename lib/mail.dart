import 'package:flutter/material.dart';
import 'package:sign_up/page.dart';
import 'package:url_launcher/url_launcher.dart';



class myFeedback extends StatefulWidget {
  @override
  _myFeedbackState createState() => _myFeedbackState();
}

class _myFeedbackState extends State<myFeedback> {
  String body, subject, email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Authority", textAlign: TextAlign.center,),leading: IconButton(icon: Icon(Icons.navigate_before_outlined), onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyPage()));
      }),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Text(
                  "Email Your Reports.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Enter Authority Email",
              ),
              onChanged: (newEmail) => email = newEmail,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              //child: Center(child: Text("Email Us Your Feedback."),),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Submit your location",
              ),
              onChanged: (newSub) => subject = newSub,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              //  child: Center(child: Text("Email Us Your Feedback."),),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Type your problems",
              ),
              onChanged: (newBody) => body = newBody,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: RaisedButton(
                  elevation: 10.0,
                  color: Colors.lightBlue,
                  onPressed: () {
                    sendingMail(email, subject, body);
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(
                    "Send Mail",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),SizedBox(width: 5,),
                    Icon(Icons.send),
                  ],
                  )
              ),
            ),
          ],
        ),
      ),

    );
  }

  void sendingMail(String email, String subject, String body) async {
    final url = 'mailto:$email?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
