import 'package:get/get.dart';
import 'package:todo/view/todo_list_screen.dart';
import 'package:todo/view/add_todo_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () =>  TodoListScreen(),
    ),
    GetPage(
      name: AppRoutes.addTodo,
      page: () => const AddTodoScreen(),
    ),
  ];
}
