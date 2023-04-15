// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jenosize/common/app_bar.dart';
import 'package:jenosize/common/app_drawer.dart';

class JenosizeMap extends StatefulWidget {
  const JenosizeMap({Key? key}) : super(key: key);

  @override
  State<JenosizeMap> createState() => _JenosizeMapState();
}

class _JenosizeMapState extends State<JenosizeMap> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static const CameraPosition initialPosition = CameraPosition(
      target: LatLng(13.894002837003686, 100.51634173931413), zoom: 19.0);

  static const CameraPosition targetPosition = CameraPosition(
      target: LatLng(13.894002837003686, 100.51634173931413),
      zoom: 20.0,
      bearing: 192.0,
      tilt: 60);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: commonAppBar(context, "แผนที่ บริษัท Jenosize"),
        ),
        endDrawer: myDrawer(context),
        body: GoogleMap(
            initialCameraPosition: initialPosition,
            mapType: MapType.normal,
            markers: markers.values.toSet(),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              final marker = Marker(
                markerId: MarkerId('Jenosize'),
                position: LatLng(13.894002837003686, 100.51634173931413),
                infoWindow: InfoWindow(title: 'Jenosize'),
              );

              setState(() {
                markers[const MarkerId('Jenosize')] = marker;
              });
            }),
      ),
    );
  }
}
