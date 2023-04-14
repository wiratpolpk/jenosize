import 'package:flutter/material.dart';
import 'package:jenosize/presentation/home_page.dart';
import 'package:jenosize/presentation/jenosize_map.dart';
import 'package:jenosize/presentation/restaurant_search.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(
                ClampingScrollWrapper.builder(context, widget!),
                breakpoints: const [
                  ResponsiveBreakpoint.resize(350, name: MOBILE),
                  ResponsiveBreakpoint.resize(600, name: TABLET),
                  ResponsiveBreakpoint.resize(800, name: DESKTOP),
                  ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
                ]),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        routes: <String, WidgetBuilder>{
          '/homePage': ((context) => const HomePage()),
          '/restaurantSearch': ((context) => const RestaurantSearch()),
          '/jenosizeMap': ((context) => const JenosizeMap()),
        });
  }
}
