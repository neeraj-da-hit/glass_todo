import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/todo_controller.dart';
import '../data/todo.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo todo;
  final int index;

  const EditTodoScreen({
    super.key,
    required this.todo,
    required this.index,
  });

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final TodoController controller = Get.find();

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  late Priority selectedPriority;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    descriptionController =
        TextEditingController(text: widget.todo.description);
    selectedPriority = widget.todo.priority;
    selectedDate = widget.todo.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: _appBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _titleInput(),
                      const SizedBox(height: 16),
                      _descriptionInput(),
                      const SizedBox(height: 24),
                      _datePicker(),
                      const SizedBox(height: 24),
                      _prioritySelector(),
                    ],
                  ),
                ),
              ),
              _updateButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= APP BAR =================

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: const Text(
        "Edit Task",
        style: TextStyle(color: Colors.black),
      ),
      leadingWidth: 80,
      leading: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      ),
    );
  }

  // ================= INPUTS =================

  Widget _titleInput() {
    return _inputContainer(
      TextField(
        controller: titleController,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          hintText: "Task title",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _descriptionInput() {
    return _inputContainer(
      TextField(
        controller: descriptionController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: "Description",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _inputContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  // ================= DATE PICKER =================

  Widget _datePicker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        title: const Text("Due Date"),
        subtitle: Text(
          selectedDate == null
              ? "No date selected"
              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
        ),
        trailing: const Icon(Icons.calendar_today),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            initialDate: selectedDate ?? DateTime.now(),
          );
          if (picked != null) {
            setState(() => selectedDate = picked);
          }
        },
      ),
    );
  }

  // ================= PRIORITY =================

  Widget _prioritySelector() {
    return Row(
      children: Priority.values.map((p) {
        final isSelected = p == selectedPriority;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedPriority = p),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                ),
              ),
              child: Text(
                p.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ================= UPDATE BUTTON =================

  Widget _updateButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _updateTodo,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          "Update Task",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ================= LOGIC =================

  void _updateTodo() {
    if (titleController.text.trim().isEmpty) return;

    controller.updateTodo(
      index: widget.index,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      priority: selectedPriority,
      dueDate: selectedDate,
    );

    Get.back();
  }
}
