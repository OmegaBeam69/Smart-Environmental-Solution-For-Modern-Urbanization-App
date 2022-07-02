import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sign_up/page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  MyHome({Key key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _phonecontroller = TextEditingController();
  TextEditingController _phonecontroller1 = TextEditingController();
  phoneAuth() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: _phonecontroller.text,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          var result = await _auth.signInWithCredential(credential);
          User user = result.user;
          if (user != null) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyPage()));
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, int resendtoken) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Enter your code",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  children: [
                    TextField(
                      controller: _phonecontroller1,
                    ),
                    RaisedButton(onPressed: ()async {
                      var smscode = _phonecontroller1.text;
                      PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(verificationId: verificationId ,smsCode: smscode);
                           var result = await _auth.signInWithCredential(phoneAuthCredential);
          User user = result.user;
          if (user != null) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyPage()));
          }
                    }, child: Text("Sign In"),),
                  ],
                ),
              );
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                "Phone number authentication",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                controller:_phonecontroller,
                decoration: new InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1.5),
                )),
              ),
              RaisedButton(
                onPressed: () {
                  phoneAuth();
                },
                child: Text("Send OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
