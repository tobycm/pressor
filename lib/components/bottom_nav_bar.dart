import 'package:flutter/material.dart';
import 'package:pressor/pages/home.dart';

class BottomNavBar extends StatefulWidget {
  final void Function(Widget page)? setPage;

  const BottomNavBar({super.key, this.setPage});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  var currentIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;

      Widget page;
      switch (currentIndex) {
        case 0:
          page = Home();
          break;
        case 1:
          page = Placeholder();
          break;
        case 2:
          page = Placeholder();
          break;
        default:
          throw UnimplementedError('no widget for $currentIndex');
      }

      if (widget.setPage != null) widget.setPage!(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      // selectedIconTheme: IconThemeData(color: Color(0xFF5BCEFA)),
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: currentIndex,
      onTap: onItemTapped,
    );
  }
}
