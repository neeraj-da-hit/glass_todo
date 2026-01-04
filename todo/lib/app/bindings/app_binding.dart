import 'package:get/get.dart';
import '../../controllers/todo_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TodoController(), permanent: true);
  }
}
