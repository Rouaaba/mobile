import 'package:flutter/material.dart';
import 'package:my_project/models/todo.dart';
import 'package:my_project/service/category_service.dart';
import 'package:intl/intl.dart';
import 'package:my_project/service/todo_service.dart';
class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitleController = TextEditingController();

  var _todoDescriptionController = TextEditingController();

  var _todoDateController = TextEditingController();

  var _selectedValue;

  var _categories = <DropdownMenuItem>[];
  var _todoService=TodoService();
  List<Todo> _todoList = [];

  final GlobalKey<ScaffoldState> _globalKey= GlobalKey<ScaffoldState>();

  @override
  initState(){
  super.initState();
  _loadCategories();
  }
  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });

  }

  DateTime _dateTime=DateTime.now();
  _selectedTodoDate(BuildContext context) async{
    var _pickeddate= await showDatePicker(context: context, initialDate: _dateTime, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if(_pickeddate!=null){
        setState(() {
          _dateTime=_pickeddate;
          _todoDateController.text=DateFormat('dd-MM-yyyy').format(_pickeddate);
        });
    }
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
        title: Text('create a todo'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller:  _todoTitleController,
            decoration: InputDecoration(
              labelText: 'Title',
              hintText:  'Write todo title',
            ),
          ),
          TextField(
            controller:  _todoDescriptionController,
            decoration: InputDecoration(
                labelText: 'Description',
                hintText:  'Write todo description',
            ),
          ),
          TextField(
            controller:  _todoDateController,
            decoration: InputDecoration(
                labelText: 'Date',
                hintText:  'Pick a Date',
              prefixIcon: InkWell(
                onTap: (){_selectedTodoDate(context);},
                child: Icon(Icons.calendar_today),
              ),
            ),
          ),
          DropdownButtonFormField(
              value: _selectedValue,
              hint: Text("Category"),
              items: _categories,
              onChanged: (value){
                setState(() {
                  _selectedValue = value;
                });
              }
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: ()async{
              var todoObject=Todo();
              todoObject.title=_todoTitleController.text;
              todoObject.description=_todoDescriptionController.text;
              todoObject.isFinished=0;
              todoObject.category=_selectedValue;
              todoObject.todoDate=_todoDateController.text;

              
              var _todoService=TodoService();
              var result = await _todoService.saveTodo(todoObject);
              if(result>0)
                {
                  _showSuccessSnackBar(Text('Created!'));
                }
              print(result);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor : Colors.blue,
            ),
            child: const Text("Save"),
          )

        ],
      ),
    );
  }
}
