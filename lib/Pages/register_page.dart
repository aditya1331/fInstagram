import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double? _deviceWidth, _deviceHeight;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  FirebaseService? _firebaseService;
  String? _name, _email, _password;
  File? _image; //This file module is from dart.io not dart.html

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _titleWidget(),
                _profileImage(),
                _registrationForm(),
                _registerButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return const Text(
      'Finstagran',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 25,
      ),
    );
  }

  Widget _registerButton()  {
    return MaterialButton(
      onPressed: () async {
        if (_registerFormKey.currentState!.validate() && _image != null) {
          _registerFormKey.currentState!.save();
          bool _results =  await _firebaseService!.registerUser(
              name: _name!,
              email: _email!,
              password: _password!,
              image: _image!);
          if (_results) Navigator.pop(context);
        }
      },
      minWidth: _deviceWidth! * 0.5,
      height: _deviceHeight! * 0.05,
      color: Colors.red,
      child: const Text(
        "Register",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _registrationForm() {
    return Container(
      height: _deviceHeight! * 0.3,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _nameTextField(),
            _emailTextField(),
            _passwordTextField(),
          ],
        ),
      ),
    );
  }

  Widget _profileImage() {
    var _imageProvider = _image != null
        ? FileImage(_image!)
        : NetworkImage("https://i.pravatar.cc/150?img=5");
    return GestureDetector(
      onTap: () {
        FilePicker.platform
            .pickFiles(
                type: FileType
                    .image) //then function indicates the function to executed after image is extracted
            .then((_result) => {
                  setState(() {
                    _image = File(_result!.files.first.path!);
                  })
                });
      },
      child: Container(
        height: 0.15 * _deviceHeight!,
        width: _deviceWidth! * 0.15,
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: _imageProvider as ImageProvider,
        )),
      ),
    );
  }

  Widget _nameTextField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "Name..."),
      validator: (_value) => _value!.length > 0 ? null : "Please enter a name",
      onSaved: (_value) {
        setState(() {
          _name = _value;
        });
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "Email..."),
      onSaved: (_value) {
        setState(() {
          _email = _value;
        });
      },
      validator: (_value) {
        bool _results = _value!.contains(RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"));
        return _results ? null : "Please enter a valid email";
      }, //validates the input
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(hintText: "Password..."),
      onSaved: (_value) {
        setState(() {
          _password = _value;
        });
      },
      validator: (_value) => _value!.length > 6
          ? null
          : "Please enter a password greater than charcters",
      //validates the input
    );
  }
}
