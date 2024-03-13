// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:felix/pages/historyPage.dart';
import 'package:felix/pages/homepage.dart';
import 'package:felix/pages/profile.dart';
import 'package:felix/pages/wishlist.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required int currentIndex});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: Container(
          height: 70.0,
          color: Colors.black,
          child: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: "Home",
              ),
              Tab(
                icon: Icon(Icons.favorite),
                text: "Wishlist",
              ),
              Tab(
                icon: Icon(Icons.history),
                text: "History",
              ),
              Tab(
                icon: Icon(Icons.person),
                text: "Profile",
              ),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            HomePage(),
            WishlistPage(),
            HistoryPage(
                // accountId: '',
                // watchList: [],
                // status: '',
                ),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
