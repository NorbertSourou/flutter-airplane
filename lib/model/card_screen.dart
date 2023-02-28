import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class CardScreen extends StatefulWidget {
  final trackList;

  const CardScreen({Key? key, this.trackList}) : super(key: key);

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  static LatLng _center = const LatLng(19.0759837, 72.8776559);

  List<LatLng> latLen = [
    // LatLng(1676245034,  33.9455),
    //   LatLng(1676245056, 33.9436),
    // LatLng(26.850000, 80.949997),
    // LatLng(24.879999, 74.629997),
    // LatLng(16.166700, 74.833298),
    // LatLng(12.971599, 77.594563),
  ];
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;
  List<LatLng> polylineCoordinates = [];

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  MapType _currentMapType = MapType.normal;
  final Set<Polyline> _polyline = {};

  @override
  void initState() {
    _center =
        LatLng(widget.trackList["path"][0][1], widget.trackList["path"][0][1]);
    for (int i = 0; i < widget.trackList["path"].length; i++) {
      latLen.add(LatLng(double.parse(widget.trackList["path"][i][1].toString()),
          double.parse(widget.trackList["path"][i][2].toString())));
    }

    for (int i = 0; i < latLen.length; i++) {
      _markers.add(
          // added markers
          Marker(
        markerId: MarkerId(i.toString()),
        position: latLen[i],
        infoWindow: InfoWindow(
          title: 'Emplacement $i',
          snippet: 'Emplacement $i',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      setState(() {});
      _polyline.add(Polyline(
        polylineId: PolylineId('1'),
        points: latLen,
        color: Colors.green,
      ));
    }
    // getPolyPoints();
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAf3PGy_gS9QH1CIvgIVCuw-k-S71i-Pv0", // Your Google Map Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Maps Sample App'),
        //   backgroundColor: Colors.green[700],
        // ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
                myLocationButtonEnabled: true,
                compassEnabled: true,
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
                polylines: _polyline),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: _onMapTypeButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.map, size: 36.0),
                    ),
                    const SizedBox(height: 16.0),
                    FloatingActionButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  child: Text(
                                    "Détails du vol ${widget.trackList["icao24"]}",
                                    style: GoogleFonts.montserrat(fontSize: 20),
                                  ),
                                ),
                                ListTile(
                                  // leading: Icon(Icons.share),
                                  title: Text(
                                      'Code : ${widget.trackList["callsign"]}'),
                                ),
                                ListTile(
                                  title: Text(
                                      'Date et heure de départ : ${DateFormat('dd-MM-yyyy à hh:mm').format(DateTime.fromMillisecondsSinceEpoch(widget.trackList["startTime"].toInt() * 1000))}'),
                                ),
                                ListTile(
                                  // leading: Icon(Icons.share),
                                  title: Text(
                                      'Heure d\' arrivée : ${DateFormat('dd-MM-yyyy à hh:mm').format(DateTime.fromMillisecondsSinceEpoch(widget.trackList["endTime"].toInt() * 1000))}'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.list, size: 36.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
