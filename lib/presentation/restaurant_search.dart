// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jenosize/common/app_bar.dart';
import 'package:jenosize/common/app_drawer.dart';
import 'package:jenosize/model/place.dart';
import 'package:jenosize/common/constant.dart';
import 'package:dio/dio.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:uuid/uuid.dart';

class RestaurantSearch extends StatefulWidget {
  const RestaurantSearch({Key? key}) : super(key: key);

  @override
  State<RestaurantSearch> createState() => _RestaurantSearchState();
}

class _RestaurantSearchState extends State<RestaurantSearch> {
  // static const nearbyLat = 13.894002837003686;
  // static const nearbyLng = 100.51634173931413;
  // static const apiKey = 'AIzaSyCeiXutMgI_F-T7n5dSqNGcxrkvXQZ0UZU';
  late String _heading;
  late List<Place> _placesList;
  final List<Place> _suggestedList = [];
  // int _calls = 0;

  final TextEditingController _searchController = TextEditingController();
  // Timer? _throttle;
  var uuid = const Uuid();
  String? _sessionToken;

  @override
  void initState() {
    super.initState();
    _heading = "ไม่พบข้อมูล";
    _placesList = _suggestedList;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getLocationResults(_searchController.text);
    // if (_throttle?.isActive ?? false) _throttle?.cancel();
    // _throttle = Timer(const Duration(milliseconds: 500), () {
    //   getLocationResults(_searchController.text);
    // });
  }

  void getLocationResults(String input) async {
    if (input.isEmpty) {
      setState(() {
        _heading = "ไม่พบข้อมูล";
      });
      return;
    }

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    // String type = '(regions)';
    String type = 'restaurant';
    String request =
        '$baseURL?input=$input&language=th&location=13.894002837003686%2C100.51634173931413&radius=500&key=$PLACE_API_KEY&type=$type&_sessiontoken=$_sessionToken';
    Response response = await Dio().get(request);

    final predictions = response.data['predictions'];

    // print(predictions);

    List<Place> displayResults = [];

    for (var i = 0; i < predictions.length; i++) {
      String name = predictions[i]['description'];
      String placeId = predictions[i]['place_id'];
      String details = "ร้านอาหาร";
      displayResults.add(Place(name, details, placeId));
    }
    setState(() {
      _heading = "ผลการค้นหา";
      _placesList = displayResults;
      // _calls++;
    });
  }

  Future<String?> getLocationPhotoRef(placeId) async {
    String placeImgRequest =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&language=th&fields=photo&key=$PLACE_API_KEY&sessiontoken=$_sessionToken';
    Response placeDetails = await Dio().get(placeImgRequest);
    // print('place details: ${placeDetails.data["result"]["name"]}');
    return placeDetails.data?["result"]?["photos"]?[0]["photo_reference"];
  }

  Future<String?> getLocationName(placeId) async {
    String placeNameRequest =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&language=th&fields=name&key=$PLACE_API_KEY&sessiontoken=$_sessionToken';
    Response placeDetails = await Dio().get(placeNameRequest);
    // print('place details: ${placeDetails.data["result"]["name"]}');
    return placeDetails.data?["result"]["name"];
  }

  Future<String?> getLocationAddress(placeId) async {
    String placeAddressRequest =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&language=th&fields=formatted_address%2Cformatted_phone_number&key=$PLACE_API_KEY&sessiontoken=$_sessionToken';
    Response placeDetails = await Dio().get(placeAddressRequest);
    // print('place details: ${placeDetails.data["result"]["name"]}');
    String? address = placeDetails.data?["result"]["formatted_address"];
    String? phone =
        placeDetails.data?["result"]["formatted_phone_number"] == null
            ? ""
            : "โทร: ${placeDetails.data?["result"]["formatted_phone_number"]}";
    String details = "รายละเอียด: $address $phone";
    // print('detail addr: $phone');
    return details;
  }

  Widget getphoto(photoReference) {
    const baseUrl = "https://maps.googleapis.com/maps/api/place/photo";
    const maxWidth = "400";
    const maxHeight = "200";
    final url =
        "$baseUrl?maxwidth=$maxWidth&maxheight=$maxHeight&photoreference=$photoReference&key=$PLACE_API_KEY";
    return photoReference != null
        ? CachedNetworkImage(imageUrl: url)
        : const Image(image: AssetImage('assets/images/no_image_icon.png'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: commonAppBar(context, "ค้นหาร้านอาหาร"),
        ),
        endDrawer: myDrawer(context),
        body: Column(
          children: <Widget>[
            // Text("API calls: $_calls"),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                showCursor: false,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: InputBorder.none),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                _heading,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _placesList.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildPlaceCard(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlaceCard(BuildContext context, int index) {
    return Hero(
      tag: "SelectedTrip-${_placesList[index].name}",
      transitionOnUserGestures: true,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
        ),
        child: Card(
          child: InkWell(
            child: Row(
              children: <Widget>[
                FutureBuilder<String?>(
                  future: getLocationPhotoRef(_placesList[index].placeId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // print('photo: ${snapshot.data}');
                      return Column(
                        children: <Widget>[
                          SizedBox(
                              width: 100,
                              height: 100,
                              child: getphoto(snapshot.data)),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const SizedBox(
                      width: 100,
                      height: 100,
                      child: Image(
                          image: AssetImage('assets/images/no_image_icon.png')),
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        FutureBuilder<String?>(
                          future: getLocationName(_placesList[index].placeId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                children: <Widget>[
                                  Flexible(
                                    child: AutoSizeText(snapshot.data!,
                                        maxLines: 3,
                                        style: const TextStyle(fontSize: 20.0)),
                                  ),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const Text("");
                          },
                        ),
                        FutureBuilder<String?>(
                          future:
                              getLocationAddress(_placesList[index].placeId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                children: <Widget>[
                                  Flexible(
                                    child: AutoSizeText(snapshot.data!,
                                        maxLines: 3,
                                        style: const TextStyle(fontSize: 16.0)),
                                  ),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const Text("");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
