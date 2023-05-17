import 'package:my_project/models/category.dart';
import 'package:my_project/repositories/repository.dart';

class CategoryService{
  Repository _repository = Repository();
  CategoryService(){
    _repository = Repository();
  }
  saveCategory(Category category) async {
    return await _repository.insertData("Categories", category.categoryMap());
  }
  readCategory() async {
    return await _repository.readData("Categories");
  }

  readCategoryById(categoryId) async {
    return await _repository.readDataById('Categories',categoryId);
  }

  updateCategory(Category category) async {
    return await _repository.updateData('Categories',category.categoryMap());
  }

  deleteCategory(categoryId) async {
    return await _repository.deleteData("Categories", categoryId);
  }
}