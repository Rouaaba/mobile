import 'package:flutter/material.dart';
import 'package:my_project/screens/categories_screen.dart';
import 'package:my_project/screens/home_screen.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [UserAccountsDrawerHeader(accountName: Text('Omar Romdhane'), accountEmail: Text('Romdaneo@gmailcom'),decoration: BoxDecoration(color: Colors.blueAccent)
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()))
          ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Categories'),
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoriesScreen())),
            )
          ],
        ),

      ),
    );
  }
}
