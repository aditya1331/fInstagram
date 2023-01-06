import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:finstagram/Pages/feed_page.dart';
import 'package:finstagram/Pages/profile_page.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _currentPage = 0;
  FirebaseService? _firebaseService;

  final List<Widget> _pages = [
    feedPage(),
    ProfilePage(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar(),
      body: _pages[_currentPage!],
      appBar: AppBar(
        title: const Text(
          "FInstagram",
        ),
        actions: [
          GestureDetector(
            onTap: _postImage,
            child: const Icon(Icons.add_a_photo),
          ),
          Padding(
              padding: const EdgeInsets.only(
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
          BottomNavigationBarItem(label: "Feed", icon: Icon(Icons.feed)),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.account_box),
          )
        ]);
  }

  void _postImage() async {
    FilePickerResult? _redult =
        await FilePicker.platform.pickFiles(type: FileType.image);
  File _image = File(_redult!.files.first.path!);
  await _firebaseService!.postImage(_image);
  }
}
