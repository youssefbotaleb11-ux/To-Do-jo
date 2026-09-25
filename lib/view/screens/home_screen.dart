import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/model/task_model.dart';
import 'package:todo_app/view/screens/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // متغير لتحديد الفلتر الحالي (0: الكل، 1: قيد الانتظار، 2: المكتملة)
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. الجزء العلوي (الصورة والاسم وجرس الإشعارات)
              Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0xFFE8EEF5),
                    child: Icon(Icons.person, color: Color(0xFF3F51B5), size: 28),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Good Morning ',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          Text('👋', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.black54),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. الـ Card الأزرق للإحصائيات (Tasks, Done, Pending)
              ValueListenableBuilder(
                valueListenable: Hive.box<TaskModel>('Tasks').listenable(),
                builder: (context, Box<TaskModel> box, _) {
                  int totalTasks = box.length;
                  int doneTasks = box.values.where((task) => task.status == StatusTask.done).length;
                  int pendingTasks = totalTasks - doneTasks;

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3F51B5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('$totalTasks', 'Tasks'),
                        _buildDivider(),
                        _buildStatItem('$doneTasks', 'Done'),
                        _buildDivider(),
                        _buildStatItem('$pendingTasks', 'Pending'),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 3. عنوان القسم مع زر مسح المهام المكتملة والفلاتر
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Tasks",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      // زر مسح المهام المكتملة الجديدة
                      IconButton(
                        icon: const Icon(Icons.cleaning_services_outlined, color: Colors.redAccent, size: 20),
                        tooltip: 'Clear Done Tasks',
                        onPressed: () async {
                          var box = Hive.box<TaskModel>('Tasks');
                          var doneTasks = box.values.where((task) => task.status == StatusTask.done).toList();
                          for (var task in doneTasks) {
                            await task.delete();
                          }
                        },
                      ),
                      const SizedBox(width: 4),
                      _buildFilterChip('All', 0),
                      const SizedBox(width: 6),
                      _buildFilterChip('Pending', 1),
                      const SizedBox(width: 6),
                      _buildFilterChip('Done', 2),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 4. قائمة المهام مع الـ Logic والتحديث المباشر والسحب للحذف أو التغيير
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<TaskModel>('Tasks').listenable(),
                  builder: (context, Box<TaskModel> box, _) {
                    var allTasks = box.values.toList();
                    var filteredTasks = allTasks.where((task) {
                      if (_selectedFilterIndex == 1) {
                        return task.status == StatusTask.pending;
                      } else if (_selectedFilterIndex == 2) {
                        return task.status == StatusTask.done;
                      }
                      return true;
                    }).toList();

                    if (filteredTasks.isEmpty) {
                      return const Center(
                        child: Text(
                          'No tasks found!',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        TaskModel task = filteredTasks[index];
                        bool isDone = task.status == StatusTask.done;

                        return Dismissible(
                          key: Key(task.key.toString()),
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.check, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              await task.delete();
                              return false;
                            } else {
                              task.status = isDone ? StatusTask.pending : StatusTask.done;
                              await task.save();
                              setState(() {});
                              return false;
                            }
                          },
                          child: GestureDetector(
                            onTap: () {
                              _showEditTaskDialog(context, task);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(task.colorHex),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            decoration: isDone ? TextDecoration.lineThrough : null,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          task.description,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isDone ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isDone ? 'Done' : 'Pending',
                                      style: TextStyle(
                                        color: isDone ? Colors.green : Colors.orange,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                    onPressed: () async {
                                      await task.delete();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFE8EEF5),
        elevation: 0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Color(0xFF3F51B5)),
        label: const Text(
          'Task',
          style: TextStyle(color: Color(0xFF3F51B5), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3F51B5) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, TaskModel task) {
    TextEditingController controller = TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task Title'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter new task name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F51B5)),
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  task.title = controller.text;
                  await task.save();
                  Navigator.pop(context);
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }
}