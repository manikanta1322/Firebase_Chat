import 'dart:io';

import 'package:chat_app/firebaseupload.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'chatapp.dart';
import 'outsidedesign.dart';

class PersonalDetail extends StatefulWidget {
  @override
  State<PersonalDetail> createState() => _PersonalDetailState();
}

class _PersonalDetailState extends State<PersonalDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username = '';

  String _password = '';

  late File _imageFile;

  dynamic _imageUrl;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
    }
  }

  Future<void> _uploadImage() async {
    String url = await navigation().uploadImageToFirebase();
    _imageUrl = url;
  }

  void initState() {
    _imageFile = File('initial_file_path');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _imageFile != null
                        ? CircleAvatar(
                            radius: 50.0,
                            backgroundImage: FileImage(_imageFile),
                          )
                        : Text('No image selected'),
                    GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      GestureDetector(
                                          onTap: () {
                                            _pickImage(ImageSource.camera);
                                            Navigator.pop(context);
                                          },
                                          child: Icon(
                                            Icons.camera,
                                            size: 40,
                                          )),
                                      GestureDetector(
                                          onTap: () {
                                            _pickImage(
                                              ImageSource.gallery,
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: Icon(
                                            Icons.browse_gallery,
                                            size: 40,
                                          )),
                                      GestureDetector(
                                          onTap: () {
                                            _uploadImage();
                                            Navigator.pop(context);
                                          },
                                          child: Icon(
                                            Icons.upload_file,
                                            size: 40,
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.yellow),
                            child: Text('Upload image'))),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Username is required';
                  }
                  return null; // Return null to indicate no error
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('Username: $_username');
                    print('Password: $_password');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                                url: _imageFile,
                              )),
                    );
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
