
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:lactgo_user/nearme.dart';
import 'package:lactgo_user/profile.dart';
import 'package:lactgo_user/scdule.dart';

import 'dashboard.dart';





class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0; // Set the initial index to 2 for the "Home" icon
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {


    List<Widget> _pages = [

      Dashboard(),
      Scedule(),
      Nearmefarms(),
      ProfilePage(),



    ];

    List<Color> _iconColors = [
      Colors.grey, // About
      Colors.grey, // Media
    // Home
      // Contact

    ];

    return Scaffold(
      bottomNavigationBar: Container(

        child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _page,
          items: [
            CurvedNavigationBarItem(
              child: Icon(Icons.home , color: _iconColors[0],),
              label: 'Home',labelStyle: TextStyle( color: Colors.grey),
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.calendar_month,color: _iconColors[0]),
              label: 'schedule',labelStyle: TextStyle( color: Colors.grey),
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.location_on,color: _iconColors[0]),
              label: 'Near Me',labelStyle: TextStyle( color: Colors.grey),
            ),

            CurvedNavigationBarItem(
              child: Icon(Icons.person,color: _iconColors[0]),
              label: 'Profile',labelStyle: TextStyle( color: Colors.grey),
            ),


          ],
          color: Colors.black,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
              _iconColors = List.generate(5, (i) => i == index ? Colors.green : Colors.grey);
            });
          },
          letIndexChange: (index) => true,
        ),
      ),
      body:  _pages[_page],
    );
  }
}
