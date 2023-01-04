import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _currentPage = 0;

  List<Widget> _pages = [
    Container(
      color: Colors.green,
    ),
    Container(
      color: Colors.blue,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar(),
      body: _pages[_currentPage!],
      appBar: AppBar(
        title: const Text("FInstagram",),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.add_a_photo),
          ),
          Padding(padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          )),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.logout),
          )
        ],
      ),
    );
  }

  Widget bottomBar() {
    return BottomNavigationBar(
        currentIndex: _currentPage!,
        onTap: (_index) {
          setState(() {
            _currentPage = _index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              label: "Feed",
              icon: Icon(Icons.feed)),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.account_box),
          )

        ]);
  }
}
