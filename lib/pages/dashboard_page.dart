import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:analog_clock/analog_clock.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<String> tasks = [];
  TextEditingController taskController = TextEditingController();
  String greetingMessage = "";

  @override
  void initState() {
    super.initState();
    loadTasks();
    updateGreeting();
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = prefs.getStringList('tasks') ?? [];
    });
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', tasks);
  }

  void updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greetingMessage = "Good Morning";
    } else if (hour < 17) {
      greetingMessage = "Good Afternoon";
    } else {
      greetingMessage = "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1F1),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              color: const Color(0xFF06918D),
              // padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      'assets/images/ic_bubbles.png',
                      height: 150,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {

                      },
                    ),
                  ),
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          child: CircleAvatar(
                            radius: 36,
                            backgroundImage: AssetImage('assets/images/ic_profile.png'),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Welcome Freya',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                    width: 100,
                    child: AnalogClock(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      width: 100.0,
                      isLive: true,
                      hourHandColor: Colors.black,
                      minuteHandColor: Colors.black,
                      secondHandColor: Colors.red,
                      showNumbers: true,
                      showAllNumbers: true,
                      textScaleFactor: 1.2,
                      showTicks: false,
                      showDigitalClock: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    greetingMessage,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tasks list',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Card(
                        color: const Color(0xFFE8F5E9),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(tasks[index]),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        tasks.removeAt(index);
                                        saveTasks();
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: FloatingActionButton(
                                onPressed: () => showAddTaskDialog(context),
                                backgroundColor: const Color(0xFF009688),
                                child: const Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            BottomNavigationBar(
              backgroundColor: Colors.white,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: CircleAvatar(
                    backgroundColor: Color(0xFF009688),
                    radius: 25,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(hintText: 'Enter task name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  setState(() {
                    tasks.add(taskController.text);
                    saveTasks();
                  });
                  taskController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}