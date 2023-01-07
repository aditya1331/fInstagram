import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class feedPage extends StatefulWidget {


  @override
  State<feedPage> createState() => _feedPageState();
}

class _feedPageState extends State<feedPage> {
  FirebaseService? _firebaseService;
  double? _deviceHeight, _deviceWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    _deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Container(
      height: _deviceHeight!,
      width: _deviceWidth!,
      child: _postListView(),
    );
  }

  Widget _postListView() {
    return StreamBuilder<QuerySnapshot>
      (stream: _firebaseService!.getLatestPosts(),
        builder: (BuildContext _context, AsyncSnapshot _snapshot) {
          if (_snapshot.hasData) {
            List _posts = _snapshot.data!.docs.map((e) => e.data())
                .toList(); //e means iterating through each element
            print(_posts);

            return ListView.builder(itemCount: _posts.length,
              itemBuilder: (BuildContext context, int index) {
                Map _post = _posts[index];
                return Container(
                  margin:  EdgeInsets.symmetric(vertical: _deviceHeight!*0.01,horizontal: _deviceWidth!*0.05),
                  height: _deviceHeight! * 0.3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            _post["image"]),
                      )),
                );
              },);
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
