import 'package:flutter/material.dart';
import 'package:my_project/screens/categories_screen.dart';
import 'package:my_project/screens/home_screen.dart';
import 'package:my_project/screens/todos_by_category.dart';
import 'package:my_project/service/category_service.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {

  List<Widget> _categoryList = [];
  CategoryService _categoryService=CategoryService();

  @override
  initState(){
    super.initState();
    getAllCategories();
  }
  getAllCategories()async{
    var categories= await _categoryService.readCategory();
    categories.forEach((category){
      setState(() {
        _categoryList.add(InkWell(
          onTap: ()=>Navigator.push(context, new MaterialPageRoute(builder: (context)=>new TodosByCategory(category: category['name'],))),
          child: ListTile(
            title: Text(category['name']),
          ),
        ));
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [UserAccountsDrawerHeader(accountName: Text('Rouaa Ben Ayed'), accountEmail: Text('Roouaa.ba.3@gmailcom'),decoration: BoxDecoration(color: Colors.blueAccent)
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()))
          ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Categories'),
              onTap: ()=>Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>CategoriesScreen())),
            ),
            Divider(),
            Column(children: _categoryList
            ),
          ],
        ),

      ),
    );
  }
}
