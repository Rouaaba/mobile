import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_project/helpers/drawer_navigation.dart';
import 'package:my_project/models/todo.dart';
import 'package:my_project/screens/todo_screen.dart';
import 'package:my_project/service/todo_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TodoService _todoService;
  List<Todo> _todoList = [];

  @override
  initState(){
    super.initState();
    getAllTodos();
  }

  getAllTodos()async {
    _todoService = TodoService();
    _todoList = <Todo>[];
    var todos= await _todoService.readTodos();
    todos.forEach((todo){
      setState(() {
        var model=Todo();
        model.id=todo['id'];
        model.title=todo['title'];
        model.description=todo['description'];
        model.category=todo['category'];
        model.todoDate=todo['todoDate'];
        model.isFinished=todo['isFinished'];
        _todoList.add(model);
      });
    });
  }

  _deleteFormDialog(BuildContext context, todoId)
  {
    showDialog(context: context,barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: [
          TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  foregroundColor:MaterialStateProperty.all<Color>(Colors.white) ),
              onPressed: (){
                Navigator.pop(context);
              } ,
              child: Text('Cancel')),
          TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  foregroundColor:MaterialStateProperty.all<Color>(Colors.white)),
              onPressed: () async {
                var result = await _todoService.deleteTodo(todoId);
                if(result > 0){
                  Navigator.pop(context);
                  _todoList.clear();
                  getAllTodos();
                }
              },
              child: Text('Delete'))
        ],
        title: Text('Are you sure you want to delete this ?'),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoList'),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(itemCount: _todoList.length,itemBuilder: (context,index){
        return Padding(
          padding: EdgeInsets.only(top:8.0, left: 8.0,right: 8.0),
          child: Padding(
            padding: EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0)
              ),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_todoList[index].title?? 'No Title'),
                    Text(_todoList[index].category?? 'No Category') ,
                    IconButton(onPressed: (){
                      _deleteFormDialog(context, _todoList[index].id);
                    }, color:Colors.red ,icon: Icon(Icons.delete))


                  ],
                ),
                subtitle: Text(_todoList[index].todoDate?? 'No todoDate'),


              )
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: ( ) => Navigator.of(context)
            .push(MaterialPageRoute(builder : (context)=>TodoScreen())),
        child: Icon(Icons.add),
      ),
    );
  }
}
