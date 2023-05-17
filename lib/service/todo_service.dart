import 'package:my_project/models/todo.dart';
import 'package:my_project/repositories/repository.dart';

class TodoService {

  Repository _repository = Repository();

  TodoService() {
    _repository = Repository();
  }


  saveTodo(Todo todo) async {
    return await _repository.insertData('todos', todo.todoMap());
  }

  readTodos() async {
    return await _repository.readData('todos');
  }

  readTodoByCategory(category) async {
    return await _repository.readDataByColumnName(
        'todos', 'category', category);
  }

  deleteTodo(todoId) async {
    return await _repository.deleteData("todos", todoId);
  }
}