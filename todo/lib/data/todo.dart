enum Priority { high, medium, low }

class Todo {
  final String title;
  final String description; // ✅ NEW
  final DateTime? dueDate;   // ✅ NEW
  final String time;
  final Priority priority;
  final bool isPersonal;
  bool isDone;

  Todo({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.time,
    required this.priority,
    this.isPersonal = false,
    this.isDone = false,
  });
}
