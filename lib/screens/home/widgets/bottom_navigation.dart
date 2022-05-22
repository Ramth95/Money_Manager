import 'package:flutter/material.dart';
import 'package:money_management_app/screens/home/screen_home.dart';

class MoneyBottomNavigation extends StatelessWidget {
  const MoneyBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: ScreenHome.selectedIndexNotifier,
        builder: (BuildContext ctx, int updatedIndex, Widget? child) {
          return BottomNavigationBar(
              selectedItemColor: Colors.green,
              selectedFontSize: 17,
              currentIndex: updatedIndex,
              onTap: (newIndex) {
                ScreenHome.selectedIndexNotifier.value = newIndex;
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.money,
                    size: 30,
                  ),
                  label: 'Transactions',
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.category,
                      size: 30,
                    ),
                    label: 'Categories'),
              ]);
        });
  }
}
