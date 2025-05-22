import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:railway/home%20pages/home_page.dart';
import 'package:railway/profile/profile.dart';
import 'package:railway/setting/setting.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  _onTap(int i) {
    setState(() {
      _selectedIndex = i;
      controller!.index = _selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: TabBarView(
    physics: NeverScrollableScrollPhysics(),
    controller: controller,
    children: [
      HomePage(),
      Setting(),
      Profile(),
    ],
          ),
          bottomNavigationBar: BottomNavigationBar(
    items: const [
      BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home), label: "Home"),
      BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.settings), label: "Setting"),
      BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.profile_circled), label: 'Profile')
    ],
    currentIndex: _selectedIndex,
    backgroundColor: Colors.grey[300],
    selectedLabelStyle: TextStyle(fontSize: 12),
    showSelectedLabels: true,
    selectedItemColor: Colors.blueAccent,
    unselectedItemColor: Colors.blueGrey,
    type: BottomNavigationBarType.fixed,
    onTap: _onTap,
          ),
        );
  }
}
