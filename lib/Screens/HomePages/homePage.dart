import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/Screens/HomePages/widgets/homePageContent.dart';
import 'package:partner/Screens/HomePages/widgets/orderHistory.dart';
import 'package:partner/Screens/ProfilePages/profilePage.dart';
import 'package:partner/provider/mProvider/commanProviders.dart';
import 'package:partner/provider/providers.dart';
import 'package:partner/services/apiService.dart';
import 'package:partner/shared/custom_widgets.dart';
import 'package:partner/values/MyColors.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _selectedItemColor = AppColors.purewhite;
  final _unselectedItemColor = AppColors.purple1;
  final _selectedBgColor = AppColors.purple1;
  final _unselectedBgColor = AppColors.purewhite;
  int currentState = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePageContent(),
    orderHistory(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    ref.read(bottomNavigationState.notifier).state = index;
    /* setState(() {
      _selectedIndex = index;
    });*/
  }

  Color _getBgColor(int index) => currentState == index ? _selectedBgColor : _unselectedBgColor;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    currentState = ref.watch(bottomNavigationState);
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
        currentIndex: currentState,
        selectedItemColor: _selectedItemColor,
        unselectedItemColor: _unselectedItemColor,
        // backgroundColor: ,
        iconSize: 40,
        onTap: _onItemTapped,
      ),

      body: Center(
        child: _widgetOptions.elementAt(currentState),
      ),
      // body:
    );
  }
}
