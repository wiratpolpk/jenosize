// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:jenosize/common/button_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 200,
              height: 400,
              child: Image(
                image: AssetImage('assets/images/logo_jenosize.png'),
              ),
            ),
            goToRestaurantSearch(),
            SizedBox(
              height: 24,
            ),
            goToJenosizeMap(),
          ],
        ),
      ),
    ));
  }

  Widget goToRestaurantSearch() => ButtonWidget(
      text: 'ค้นหาร้านอาหาร',
      onClicked: () {
        Navigator.pushNamed(context, '/restaurantSearch');
      });

  Widget goToJenosizeMap() => ButtonWidget(
      text: 'แผนที่ บริษัท Jenosize',
      onClicked: () {
        Navigator.pushNamed(context, '/jenosizeMap');
      });
}
