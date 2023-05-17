import 'package:flutter/material.dart';
import 'package:my_project/models/category.dart';
import 'package:my_project/screens/home_screen.dart';
import 'package:my_project/service/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController =TextEditingController();
  var _categoryDescriptionController =TextEditingController();

  var _editCategoryNameController =TextEditingController();
  var _editCategoryDescriptionController =TextEditingController();

  var _category= Category();
  var _categoryService=CategoryService();

  var category;
  List<Category> _categoryList = [];
  @override
  void initState(){
    super.initState();
    getAllCategories();
}

final GlobalKey<ScaffoldState> _globalKey= GlobalKey<ScaffoldState>();

  getAllCategories() async {
    var categories = await _categoryService.readCategory();
    categories.forEach((category)
    {
      setState(() {
        var categoryModel= Category();
        categoryModel.name=category['name'];
        categoryModel.description=category['description'];
        categoryModel.id=category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }


  _editCategory(BuildContext context,categoryId) async
  {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text=category[0]['name']??'No Name';
      _editCategoryDescriptionController.text=category[0]['description']??'No Description';

    });
    _editFormDialog(context);
  }



  _showFormDialog(BuildContext context)
  {
    showDialog(context: context,barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: [
          TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              foregroundColor:MaterialStateProperty.all<Color>(Colors.white) ),
              onPressed: (){} ,
              child: Text('Cancel')),
          TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                  foregroundColor:MaterialStateProperty.all<Color>(Colors.white)),
              onPressed: () async {
                _category.name=_categoryNameController.text;
                _category.description=_categoryDescriptionController.text;
                var result = await _categoryService.saveCategory(_category);
                if(result > 0){
                  Navigator.pop(context);
                  _categoryList.clear();
                  getAllCategories();
                  _showSuccessSnackBar(Text('task added !'));
                  }
              },
              child: Text('Save'))
        ],
        title: Text('categories form'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _categoryNameController,
              decoration: InputDecoration(
                hintText: 'Write a category',
                labelText: 'Category'
              ),
            ),
            TextField(
              controller: _categoryDescriptionController,
              decoration: InputDecoration(
                  hintText: 'Write a decsription',
                  labelText: 'Decsription'
              ),
            )
          ],
        ),
      ),);
    });
  }


  _editFormDialog(BuildContext context)
  {
    showDialog(context: context,barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: [
          TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  foregroundColor:MaterialStateProperty.all<Color>(Colors.white) ),
              onPressed: (){} ,
              child: Text('Cancel')),
          TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                  foregroundColor:MaterialStateProperty.all<Color>(Colors.white)),
              onPressed: () async {
                _category.id=category[0]['id'];
                _category.name=_editCategoryNameController.text;
                _category.description=_editCategoryDescriptionController.text;
                var result = await _categoryService.updateCategory(_category);
                if(result > 0){
                  Navigator.pop(context);
                  _categoryList.clear();
                  getAllCategories();
                  _showSuccessSnackBar(Text('Updated!'));
                }
              },
              child: Text('Update'))
        ],
        title: Text('Edit categories form'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _editCategoryNameController,
                decoration: InputDecoration(
                    hintText: 'Write a category',
                    labelText: 'Category'
                ),
              ),
              TextField(
                controller: _editCategoryDescriptionController,
                decoration: InputDecoration(
                    hintText: 'Write a decsription',
                    labelText: 'Decsription'
                ),
              )
            ],
          ),
        ),);
    });
  }



  _deleteFormDialog(BuildContext context, categoryId)
  {
    showDialog(context: context,barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: [
          TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  foregroundColor:MaterialStateProperty.all<Color>(Colors.white) ),
              onPressed: (){} ,
              child: Text('Cancel')),
          TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  foregroundColor:MaterialStateProperty.all<Color>(Colors.white)),
              onPressed: () async {
                var result = await _categoryService.deleteCategory(categoryId);
                if(result > 0){
                  Navigator.pop(context);
                  _categoryList.clear();
                  getAllCategories();
                  _showSuccessSnackBar(Text('deleted'));
                }
              },
              child: Text('Delete'))
        ],
        title: Text('Are you sure you want to delete this ?'),
      );
    });
  }


  _showSuccessSnackBar(message){
    var _snackBar= SnackBar(content: message);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: ElevatedButton(onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen())), child: Icon(Icons.arrow_back)),
        title: Text('Categories'),
      ),
      body: ListView.builder(itemCount: _categoryList.length,itemBuilder: (contex, index)
      {
        return Padding(
          padding: EdgeInsets.only(top : 8.0,left:16.0, right:16.0 ),
          child: Card(
            elevation: 8.0,
            child: ListTile(
              leading: IconButton(icon: Icon(Icons.edit),onPressed: (){
                _editCategory(context,_categoryList[index].id);
              }),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_categoryList[index].name),
                  IconButton(onPressed: (){
                    _deleteFormDialog(context, _categoryList[index].id);
                  }, color:Colors.red ,icon: Icon(Icons.delete))

                ],
              ),
            ),
          ),
        );
      }) ,
      floatingActionButton: FloatingActionButton(onPressed: (){
        _showFormDialog(context);
      },child: Icon(Icons.add),),
    );
  }
}
