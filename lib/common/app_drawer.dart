import 'package:flutter/material.dart';
import 'package:jenosize/presentation/home_page.dart';
import 'package:jenosize/presentation/jenosize_map.dart';
import 'package:jenosize/presentation/restaurant_search.dart';

Widget myDrawer(BuildContext context) {
  return Drawer(
    child: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.only(top: 50),
            child: Column(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text("หน้าแรก"),
                    onTap: () {
                      // Home button action
                      Navigator.of(context).pop();

                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    }),

                ListTile(
                    leading: const Icon(Icons.shop),
                    title: const Text("ค้นหาร้านอาหาร"),
                    onTap: () {
                      // My Pfofile button action
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RestaurantSearch()));
                    }),

                ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text("แผนที่ บริษัท Jenosize"),
                    onTap: () {
                      // Find peoples button action
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const JenosizeMap()));
                    })

                //add more drawer menu here
              ],
            ))),
  );
}
