import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/todo_controller.dart';
import '../data/todo.dart';
import 'add_todo_screen.dart';
import 'edit_todo_screen.dart';

class TodoListScreen extends GetView<TodoController> {
  const TodoListScreen({super.key});

  // ================= HELPER METHODS =================

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String getFormattedDate() {
    final now = DateTime.now();
    return "${_weekday(now.weekday)}, ${now.day} ${_month(now.month)}";
  }

  String _weekday(int day) {
    const days = [
      "MONDAY",
      "TUESDAY",
      "WEDNESDAY",
      "THURSDAY",
      "FRIDAY",
      "SATURDAY",
      "SUNDAY"
    ];
    return days[day - 1];
  }

  String _month(int month) {
    const months = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC"
    ];
    return months[month - 1];
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Get.to(() => const AddTodoScreen());
        },
        child: const Icon(Icons.add),
      ),
      // bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(
                () => ListView(
              children: [
                _header(),
                const SizedBox(height: 20),
                _dailyGoalCard(),
                const SizedBox(height: 24),
                _sectionTitle(
                  "Tasks",
                  "${controller.totalTasks - controller.completedTasks} LEFT",
                ),
                const SizedBox(height: 12),

                // 🔥 SWIPE EDIT + DELETE (UI PRESERVED)
                ...controller.todos.asMap().entries.map((entry) {
                  final index = entry.key;
                  final todo = entry.value;

                  return Dismissible(
                    key: ValueKey('${todo.title}-$index'),

                    direction: DismissDirection.horizontal,

                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        // 👉 EDIT
                        Get.to(() => EditTodoScreen(
                          todo: todo,
                          index: index,
                        ));
                        return false;
                      } else {
                        // 👈 DELETE
                        return await _confirmDelete();
                      }
                    },

                    onDismissed: (_) {
                      controller.deleteTodo(index);
                    },

                    background: _editBackground(),
                    secondaryBackground: _deleteBackground(),

                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => EditTodoScreen(
                          todo: todo,
                          index: index,
                        ));
                      },
                      child: _taskTile(todo),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Colors.orange,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getFormattedDate(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${getGreeting()},\nAlex",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: const [
            Icon(Icons.notifications_none),
            SizedBox(width: 16),
            Icon(Icons.grid_view),
          ],
        ),
      ],
    );
  }

  // ================= DAILY GOAL =================

  Widget _dailyGoalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily Goal",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${controller.completedTasks}/${controller.totalTasks} Tasks",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${(controller.progress * 100).toInt()}% Done",
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: controller.progress,
            backgroundColor: Colors.white24,
            color: Colors.white,
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================

  Widget _sectionTitle(String title, String badge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badge,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  // ================= TASK TILE (UNCHANGED) =================

  Widget _taskTile(Todo todo) {
    Color priorityColor;
    String priorityLabel;

    switch (todo.priority) {
      case Priority.high:
        priorityColor = Colors.red;
        priorityLabel = "High";
        break;
      case Priority.medium:
        priorityColor = Colors.blue;
        priorityLabel = "Medium";
        break;
      case Priority.low:
        priorityColor = Colors.grey;
        priorityLabel = "Low";
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: todo.isDone,
            onChanged: (_) => controller.toggleTodo(todo),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    decoration:
                    todo.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (todo.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    todo.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        priorityLabel,
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (todo.dueDate != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        "${todo.dueDate!.day}/${todo.dueDate!.month}/${todo.dueDate!.year}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SWIPE BACKGROUNDS =================

  Widget _editBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      color: Colors.blue,
      child: const Icon(Icons.edit, color: Colors.white),
    );
  }

  Widget _deleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: Colors.red,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Future<bool> _confirmDelete() async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  // ================= BOTTOM NAV =================

  Widget _bottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.check_box),
          label: "Tasks",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: "Calendar",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder),
          label: "Projects",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}
