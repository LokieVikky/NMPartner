import 'package:partner/Screens/HomePages/widgets/homePageContent.dart';
import 'package:partner/Screens/HomePages/widgets/orderHistory.dart';
import 'package:partner/Screens/ProfilePages/profilePage.dart';
import 'package:partner/values/MyColors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _selectedItemColor = MyColors.purewhite;
  final _unselectedItemColor = MyColors.purple1;
  final _selectedBgColor = MyColors.purple1;
  final _unselectedBgColor = MyColors.purewhite;
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePageContent(),
    orderHistory(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Color _getBgColor(int index) =>
      _selectedIndex == index ? _selectedBgColor : _unselectedBgColor;

  Widget _buildIcon(String iconData, int index) => Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: _getBgColor(index),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: ImageIcon(AssetImage(iconData)),
      );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon('assets/images/home.png', 0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon('assets/images/car.png', 1),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon('assets/images/user.png', 2),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _selectedItemColor,
        unselectedItemColor: _unselectedItemColor,
        // backgroundColor: ,
        iconSize: 40,
        onTap: _onItemTapped,
      ),

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // body:
    );
  }
}
