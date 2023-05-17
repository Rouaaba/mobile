import 'package:flutter/material.dart';
import 'package:my_project/screens/home_screen.dart';

class app extends StatelessWidget {
  const app({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
