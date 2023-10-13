import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sparrow_v1/pages/profile_page.dart';
import '../api/apis.dart';
import '../custom_icon.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;
  Set<Polygon> _polygons = {};
  LatLng? currentPosition;
  LatLng? _tappedLocation;
  late String nightTheme;
  late String graphiteTheme;
  late double latitude;
  late double longitude;
  List<Marker> _marker = [];

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    _fetchPos();
    _loadMapStyles();
    _setMapStyle();
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error" + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  Future _fetchPos() async {
    getUserLocation().then((value) async {
      CameraPosition cameraPosition = CameraPosition(
          zoom: 3, target: LatLng(value.latitude, value.longitude));

      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      _marker.add(Marker(
        markerId: const MarkerId('1'),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: const InfoWindow(title: '🥳'),
      ));
      setState(() {});
    });
  }

  Future _loadMapStyles() async {
    nightTheme = await rootBundle.loadString('assets/earth.json');
    graphiteTheme = await rootBundle.loadString('assets/graphite.json');
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    //final theme = WidgetsBinding.instance.window.platformBrightness;
    controller.setMapStyle(nightTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      //extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Color(0xFFF5F5F5),
          iconTheme: const IconThemeData(
            color:
                Colors.black54, // Change the color of the hamburger icon here
          ),
          flexibleSpace: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  SizedBox(
                    width:
                        64, // Adjust the width of the logo container as needed
                    height:
                        64, // Adjust the height of the logo container as needed
                    child: Image.asset(
                        'assets/logo.png'), // Replace with your logo asset
                  ),
                ],
              ),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          //backgroundColor: Colors.transparent,
          //backgroundColor: ,
        ),
      ),
      drawer: Drawer(
          backgroundColor: Colors.white.withOpacity(0.9),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(40)),
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: <Widget>[
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/pofilepic.jpeg'),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "name",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                height: 2,
              ),
              ListTile(
                onTap: () {},
                selected: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.person, color: Colors.purple),
                title: const Text(
                  "Profile",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () {},
                selectedColor: Theme.of(context).primaryColor,
                selected: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.chat, color: Colors.purple),
                title: const Text(
                  "Chats",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () {},
                selectedColor: Theme.of(context).primaryColor,
                selected: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.accessibility_new_rounded,
                    color: Colors.purple),
                title: const Text(
                  "Explore",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () {},
                selectedColor: Theme.of(context).primaryColor,
                selected: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.people, color: Colors.purple),
                title: const Text(
                  "Communities",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () {},
                selectedColor: Theme.of(context).primaryColor,
                selected: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.settings, color: Colors.purple),
                title: const Text(
                  "Settings",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () async {
                  showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0))),
                          contentPadding: const EdgeInsets.only(top: 10.0),
                          content: SizedBox(
                            width: 300.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        decoration: const BoxDecoration(
                                            //color: Theme.of(context).primaryColor,
                                            ),
                                        child: const Column(
                                          children: <Widget>[
                                            Text(
                                              "Logout",
                                              style: TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 4.0,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 30,
                                      bottom: 30),
                                  child: Text(
                                    "Are you sure you want to logout?",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w200),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {},
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: const Column(
                                      children: <Widget>[
                                        Text(
                                          "Yes",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 0,
                                  color: Colors.black45,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(32.0),
                                          bottomRight: Radius.circular(32.0)),
                                    ),
                                    child: const Column(
                                      children: <Widget>[
                                        Text(
                                          "No",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                selectedColor: Theme.of(context).primaryColor,
                selected: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.logout, color: Colors.purple),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          )),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                const CameraPosition(target: LatLng(40.000, 30.000), zoom: 2),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            //myLocationEnabled: true,
            markers: Set<Marker>.of(_marker),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            circles: { Circle(
              circleId: CircleId('1'),
              center: LatLng(40.000, 30.000),
              radius: 430
            ),},
            /*onTap: (LatLng location) {
              // Create a circular polygon centered at the tapped location
              final circlePolygon = Polygon(
                polygonId: PolygonId('circle_id'), // Unique ID for the polygon
                points: _createCirclePolygonPoints(location, 5000), // 500 meters radius
                strokeWidth: 2,
                strokeColor: Colors.blue,
                fillColor: Colors.blue.withOpacity(0.2),
              );
              print(location);

              // Update the set of polygons
              setState(() {
                _polygons.add(circlePolygon);
              });
            },*/
            polygons: _polygons,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 40),
            child: SizedBox(
              height: 40,
              child: TextField(
                onTap: () {},
                onChanged: (value) {},
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  filled: true,
                  fillColor: Colors.white54,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  //borderRadius: BorderRadius.circular(20),
                  //color: Colors.grey.shade300,
                  hintText: 'Search for country.',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 15, top: 0),
                    child: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white70,
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Container(
          height: 70.0,
          color: Colors.white70,
          child: Row(
            children: [
              const Spacer(flex: 1),
              IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(user: APIs.me),
                      ),
                    );
                  }),
              const Spacer(flex: 2),
              IconButton(
                  icon: const Icon(Icons.chat),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(),
                      ),
                    );
                  }),
              const Spacer(flex: 2),
              IconButton(
                  icon: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        8), // Adjust the border radius as needed
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(
                            0.80), // Set the fill color of the square
                        border: Border.all(
                          color: Colors.purple
                              .withOpacity(0.1), // Set the color of the border
                          width: 2, // Set the width of the border
                        ),
                      ),
                      child: const Icon(
                        Custom_Icon.globe_americas,
                        //size: 32, // Set the size of the icon
                        color: Colors.white, // Set the color of the icon
                      ),
                    ),
                  ),
                  onPressed: () {}),
              const Spacer(flex: 2),
              IconButton(icon: const Icon(Icons.people), onPressed: () {}),
              const Spacer(flex: 2),
              IconButton(
                  icon: const Icon(Icons.settings_sharp), onPressed: () {}),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  List<LatLng> _createCirclePolygonPoints(LatLng center, double radiusInMeters) {
    final int sides = 360;
    final double distanceX = radiusInMeters / 1000.0; // Convert meters to kilometers
    final double distanceY = radiusInMeters / 1000.0; // Convert meters to kilometers

    final List<LatLng> points = [];

    for (int i = 0; i < sides; i++) {
      double theta = 2.0 * pi * i / sides;
      double x = center.latitude + distanceX * cos(theta);
      double y = center.longitude + distanceY * sin(theta);
      points.add(LatLng(x, y));
    }

    return points;
  }
}
