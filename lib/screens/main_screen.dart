import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'create_blog_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'settings_screen.dart';


class MainScreen extends StatefulWidget {
  String username;

  MainScreen({required this.username, super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreen(username: widget.username),
      CreateBlogScreen(username: widget.username),
      const SettingScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onUserIconPressed() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );

    final newUsername =
        Provider.of<UserProvider>(context, listen: false).username;
    setState(() {
      widget.username = newUsername;
      _widgetOptions = <Widget>[
        HomeScreen(username: widget.username),
        CreateBlogScreen(username: widget.username),
        const SettingScreen(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('David\'s Blog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _onUserIconPressed,
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Create Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
