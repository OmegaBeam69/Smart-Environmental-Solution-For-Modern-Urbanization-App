import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sign_up/page.dart';
import 'package:url_launcher/url_launcher.dart';

class myCalls extends StatefulWidget {
  @override
  _myCallsState createState() => _myCallsState();
}

class _myCallsState extends State<myCalls> {
  String mobileNo;
  var deta;
  String url =
      "https://ba850ed4-5651-40e6-807b-166ca8c8e5a0.mock.pstmn.io/data";
  Future getData() async {
    var response = await http.get(url);
    setState(() {
      var decode = jsonDecode(response.body);
      deta = decode['data'];
      print(deta);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Contact",
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
              icon: Icon(Icons.navigate_before_outlined),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyPage()));
              }),
        ),
        body: ListView.builder(
          itemCount: deta == null ? 0 : deta.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    child: Text(deta[index]["name"][0]),
                  ),
                ),
              ),
              /*Text(
                data[index]["first_name"][0] +
                    " " +
                    data[index]["last_name"][0],
                style: TextStyle(color: Colors.white),
              ),
            ),*/
              title: Text(deta[index]["name"],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text(
                deta[index]["address"],
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              trailing: FlatButton(
                  onPressed: () {
                    mobileNo = deta[index]["phone"];
                    UrlLaunch('tel:$mobileNo');
                  },
                  child: Icon(Icons.call, color: Colors.blueAccent,)),
            );
          },
        ));
  }

  void UrlLaunch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could Not Launch $url';
    }
  }
}
