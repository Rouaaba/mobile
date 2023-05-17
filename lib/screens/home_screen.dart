import 'package:flutter/material.dart';
import 'package:my_project/helpers/drawer_navigation.dart';
import 'package:my_project/screens/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoList'),
      ),
      drawer: DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: ( ) => Navigator.of(context)
            .push(MaterialPageRoute(builder : (context)=>TodoScreen())),
        child: Icon(Icons.add),
      ),
    );
  }
}
