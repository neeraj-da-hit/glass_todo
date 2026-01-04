import 'package:hive/hive.dart';
import '../data/todo.dart';

class TodoStorage {
  static const _boxName = 'todos';

  Future<Box> _openBox() async {
    return await Hive.openBox(_boxName);
  }

  Future<List<Todo>> loadTodos() async {
    final box = await _openBox();

    return box.values.map((e) {
      final map = Map<String, dynamic>.from(e);
      return Todo(
        title: map['title'],
        description: map['description'],
        priority: Priority.values[map['priority']],
        dueDate: map['dueDate'] != null
            ? DateTime.parse(map['dueDate'])
            : null,
        isDone: map['isDone'], time: '',
      );
    }).toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final box = await _openBox();
    await box.clear();

    for (final todo in todos) {
      box.add({
        'title': todo.title,
        'description': todo.description,
        'priority': todo.priority.index,
        'dueDate': todo.dueDate?.toIso8601String(),
        'isDone': todo.isDone,
      });
    }
  }
}
