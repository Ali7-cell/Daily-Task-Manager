import 'package:flutter/material.dart';
import 'package:internship_task_manager/screens/task_list_screen.dart';
import 'package:internship_task_manager/screens/counter_screen.dart';
import 'package:internship_task_manager/screens/todo_screen.dart';
import 'package:internship_task_manager/screens/login_screen.dart';
import 'package:internship_task_manager/utils/page_transitions.dart';

class HomeShell extends StatefulWidget {
  static const String routeName = '/home';

  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TaskListScreen(),
    const TodoScreen(),
    const CounterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PlanIt',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                SlidePageRoute(
                  child: const LoginScreen(),
                  direction: AxisDirection.right,
                ),
              );
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.1, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Container(
          key: ValueKey<int>(_currentIndex),
          child: _screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          elevation: 0,
          height: 70,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.task_outlined),
              selectedIcon: Icon(Icons.task_rounded),
              label: 'Tasks',
            ),
            NavigationDestination(
              icon: Icon(Icons.checklist_outlined),
              selectedIcon: Icon(Icons.checklist_rounded),
              label: 'Todo',
            ),
            NavigationDestination(
              icon: Icon(Icons.numbers_outlined),
              selectedIcon: Icon(Icons.numbers_rounded),
              label: 'Counter',
            ),
          ],
        ),
      ),
    );
  }
}

