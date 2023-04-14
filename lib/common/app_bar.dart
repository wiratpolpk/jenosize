import 'package:flutter/material.dart';

Widget commonAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: const Color.fromARGB(255, 53, 132, 202),
    leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_outlined),
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context, '/homepage');
        }),
    title: Text(title),
  );
}
