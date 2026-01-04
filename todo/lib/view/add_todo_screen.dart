import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/todo_controller.dart';
import '../data/todo.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TodoController controller = Get.find();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Priority selectedPriority = Priority.medium;
  DateTime? selectedDate;

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
              _createButton(),
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
        "New Task",
        style: TextStyle(color: Colors.black),
      ),
      leadingWidth: 80,
      leading: TextButton(
        onPressed: () => Get.back(),
        child: const Text(
          "Cancel",
          style: TextStyle(fontSize: 16),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _createTodo,
          child: const Text(
            "Done",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  // ================= INPUTS =================

  Widget _titleInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: titleController,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          hintText: "What needs to be done?",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _descriptionInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: descriptionController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: "Add a description...",
          border: InputBorder.none,
        ),
      ),
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
            initialDate: DateTime.now(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PRIORITY",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        Row(
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
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ================= CREATE BUTTON =================

  Widget _createButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _createTodo,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          "Create Task",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ================= LOGIC =================

  void _createTodo() {
    if (titleController.text.trim().isEmpty) return;

    controller.addTodo(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      priority: selectedPriority,
      dueDate: selectedDate,
    );

    Get.back();
  }
}
