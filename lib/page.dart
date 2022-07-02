import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_up/mail.dart';
import 'pollution.dart';

import 'call.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PollutionData(),
    );
  }
}

class PollutionData extends StatefulWidget {
  PollutionData({Key key}) : super(key: key);

  @override
  _PollutionDataState createState() => _PollutionDataState();
}

class _PollutionDataState extends State<PollutionData> {
  LatLng newPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Set<Polygon> myPolygon() {
    List<LatLng> polygonCoords = new List();
    polygonCoords.add(LatLng(23.912857, 90.297641));
    polygonCoords.add(LatLng(23.912859, 90.297782));
    polygonCoords.add(LatLng(23.912814, 90.297810));
    polygonCoords.add(LatLng(23.912774, 90.297806));
    polygonCoords.add(LatLng(23.912769, 90.297712));
    polygonCoords.add(LatLng(23.912772, 90.297646));
    polygonCoords.add(LatLng(23.912857, 90.297641));

    Set<Polygon> polygonSet = new Set();
    polygonSet.add(
      Polygon(
          polygonId: PolygonId('test'),
          points: polygonCoords,
          strokeColor: Colors.greenAccent.withOpacity(0.4),
          fillColor: Colors.greenAccent.withOpacity(0.4)),
    );

    return polygonSet;
  }

  bool mapToggle = false;

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    getMarkerData();
    super.initState();
    getUserLocation();
    setState(() {});
    //pollutedArea();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(23.811456, 90.406344),
    zoom: 15.4746,
  );

  void getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final GoogleMapController controller = await _controller.future;
    setState(() {
      newPosition = LatLng(position.latitude, position.longitude);
      mapToggle = true;
      
    });

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: newPosition, zoom: 17.9),
    ));
    
    
  }

  void initMarker(specify, specifyID) async {
    var markerIdVal = specifyID;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position:
          LatLng(specify['location'].latitude, specify['location'].longitude),
      infoWindow: InfoWindow(title: 'Polution Data', snippet: specify['type']),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => pollutionData()));
      },
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance.collection('data').get().then((myMocData) {
      if (myMocData.docs.isNotEmpty) {
        for (int i = 0; i < myMocData.docs.length; ++i) {
          initMarker(myMocData.docs[i].data(), myMocData.docs[i].id);
          print(myMocData.docs[i].data());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> getMarker() {
      return <Marker>[
        Marker(
            markerId: MarkerId('pd'),
            position: LatLng(23.979854, 90.319603),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: 'Pollution', snippet: 'Data'))
      ].toSet();
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: Set<Marker>.of(markers.values),
              polygons: myPolygon(),
            ),
            Positioned(
              bottom: 80,
              right: 25,
              child: GestureDetector(
                child: CircleAvatar(
                  child: Icon(
                    Icons.message,
                    size: 25,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => myFeedback()));
                },
              ),
            ),
            Positioned(
              bottom: 125,
              right: 25,
              child: GestureDetector(
                child: CircleAvatar(
                  child: Icon(
                    Icons.call,
                    size: 25,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => myCalls()));
                },
              ),
            ),
            /* Positioned(
              bottom: 170,
              right: 25,
              child: GestureDetector(
                child: CircleAvatar(
                  child: Icon(
                    Icons.warning_sharp,
                    size: 25,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => pollutionData()));
                },
              ),
            ),*/
            Positioned(
              top: 30.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 40.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter Address',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 10.0),
                      suffixIcon:
                          IconButton(icon: Icon(Icons.search), iconSize: 30.0)),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.gps_fixed),
            elevation: 5,
            onPressed: getUserLocation),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
