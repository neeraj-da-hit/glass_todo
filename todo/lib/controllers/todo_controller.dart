import 'package:get/get.dart';
import '../data/todo.dart';
import '../storage/todo_storage.dart';

class TodoController extends GetxController {
  final TodoStorage _storage = TodoStorage();

  var todos = <Todo>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final stored = await _storage.loadTodos();
    todos.assignAll(stored);
  }

  void _save() {
    _storage.saveTodos(todos);
  }

  // ================= CRUD =================

  void addTodo({
    required String title,
    required String description,
    required Priority priority,
    required DateTime? dueDate,
  }) {
    todos.add(
      Todo(
        title: title,
        description: description,
        priority: priority,
        dueDate: dueDate, time: '',
      ),
    );
    _save();
  }

  void updateTodo({
    required int index,
    required String title,
    required String description,
    required Priority priority,
    required DateTime? dueDate,
  }) {
    final old = todos[index];

    todos[index] = Todo(
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      isDone: old.isDone, time: '',
    );
    _save();
  }

  void toggleTodo(Todo todo) {
    todo.isDone = !todo.isDone;
    todos.refresh();
    _save();
  }

  void deleteTodo(int index) {
    todos.removeAt(index);
    _save();
  }

  // ================= STATS =================

  int get completedTasks =>
      todos.where((t) => t.isDone).length;

  int get totalTasks => todos.length;

  double get progress =>
      totalTasks == 0 ? 0 : completedTasks / totalTasks;
}
