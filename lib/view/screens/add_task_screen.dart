import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/model/task_model.dart';
import 'package:todo_app/view/screens/widget/choose_color_widget.dart';


class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String dropdownButtonValue = 'Pending';
  final TextEditingController titleTask = TextEditingController();
  final TextEditingController desTask = TextEditingController();
  int colorSelected = 4283215696; // القيمة الرقمية للون الظاهرة في الصورة

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Task',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title Label
            const Text(
              'Task Title',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleTask,
              decoration: InputDecoration(
                hintText: 'Design Login Screen',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Description Label
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: desTask,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Task Description...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Status Dropdown Label
            const Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropdownButtonValue,
                  isExpanded: true,
                  items: ['Pending', 'Done'].map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownButtonValue = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Choose Color Section
            const Text(
              'Choose Color',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const ChooseColorWidget(), 
            const SizedBox(height: 40),

            // Save Task Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51B5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () async {
                  log("Title: ${titleTask.text}");
                  log("Des: ${desTask.text}");
                  log("Status: $dropdownButtonValue");
                  log("Color: $colorSelected");

                 
                  await Future.delayed(const Duration(seconds: 3));

                  var taskBox = Hive.box<TaskModel>('Tasks');

                  await taskBox
                      .add(
                        TaskModel(
                          title: titleTask.text,
                          description: desTask.text,
                          status: dropdownButtonValue == "Pending"
                              ? StatusTask.pending
                              : StatusTask.done,
                          colorHex: colorSelected,
                        ),
                      )
                      .then((value) {
                    Navigator.of(context).pop();
                    titleTask.clear();
                    desTask.clear();
                    colorSelected = 4283215696;
                  }).catchError((error) {
                    Navigator.of(context).pop();
                    
                  });
                },
                child: const Text(
                  'Save Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}