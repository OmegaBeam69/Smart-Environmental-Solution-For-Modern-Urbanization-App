import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sign_up/page.dart';

class pollutionData extends StatefulWidget {
  @override
  _pollutionDataState createState() => _pollutionDataState();
}

class _pollutionDataState extends State<pollutionData> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  var deta;
  String url =
      "https://api.thingspeak.com/channels/1277552/feeds.json?api_key=EZ2IOLX7USPILEWM&results=2";
  Future getData() async {
    var response = await http.get(url);
    setState(() {
      var decode = jsonDecode(response.body);
      deta = decode['feeds'];
      // print(deta);
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
            "Data",
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
              icon: Icon(Icons.navigate_before_outlined),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyPage()));
              }),
          /*actions: [
              IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {});
                  }),
            ]*/
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: ListView.builder(
            itemCount: deta == null ? 0 : deta.length,
            itemBuilder: (context, index) {
              return ListTile(
                
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      child: Icon(Icons.cloud),
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
                title: Text(deta[index]["created_at"],
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                subtitle: Text(
                  "PM1.0: " +
                      deta[index]["field1"] +
                      " μg/m3 \n"
                          "PM2.5: " +
                      deta[index]["field2"] +
                      " μg/m3 \n"
                          "PM10: " +
                      deta[index]["field3"] +
                      " μg/m3 \n"
                          "AQI: " +
                      deta[index]["field4"] +
                      " PPM \n",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  
                ),
                
              );
            },
          ),
        ));
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    getData();
  }
}
