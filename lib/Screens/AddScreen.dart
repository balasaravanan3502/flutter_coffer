import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_task_coffer/Provider/VideoData.dart';
import '../services/Location.dart';
import '../constants.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  bool isStarted = false;
  bool isLoading = false;
  String loc = '';
  bool isPicked = false;
  bool isSubmitted = false;
  var pickedFile;

  final TextEditingController _titleField = TextEditingController();
  final TextEditingController _locField = TextEditingController();
  final TextEditingController _categField = TextEditingController();

  late File _pickedImage;

  getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    setState(() {
      _locField.text = '${location.city},${location.state}';
      isStarted = true;
    });
  }

  _imagePicker() async {
    final picker = ImagePicker();
    pickedFile = await picker.getVideo(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        isPicked = true;
        _pickedImage = File(pickedFile.path);
      } else {}
    });
  }

  _sumbit() async {
    if (isPicked) {
      isLoading = true;
      final ref = FirebaseStorage.instance.ref().child('userProfile');

      await ref.putFile(_pickedImage);

      String url = await ref.getDownloadURL();

      final SharedPreferences sharedpref =
          await SharedPreferences.getInstance();
      final uid = sharedpref.getString('uid');

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'videos': FieldValue.arrayUnion([
          {
            'userpic': '',
            'title': _titleField.text,
            'location': _locField.text,
            'category': _categField.text,
            'link': url,
            'views': 'Views',
            'days': 'Days',
            'username': 'user'
          }
        ])
      });
      final provider = Provider.of<VideoData>(context, listen: false);
      provider.fetchData();
      setState(() {
        isSubmitted = true;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleField.dispose();
    _categField.dispose();
    _locField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: isStarted
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.center,
        children: [
          if (isSubmitted)
            Center(
              child: Text(
                'The video posted successfully',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (isStarted && !isLoading && !isSubmitted)
            MaterialButton(
              onPressed: _imagePicker,
              child: !isPicked
                  ? Icon(
                      Icons.add_a_photo,
                      color: Color(0xff2D5C78),
                      size: MediaQuery.of(context).size.width * .2,
                    )
                  : BetterPlayer.network(pickedFile.path),
            ),
          if (isStarted && !isLoading && !isSubmitted)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  controller: _titleField,
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Enter Title'),
                  cursorColor: Color(0xff2D5C78),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _locField,
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Enter Location'),
                  cursorColor: Color(0xff2D5C78),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _categField,
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Enter Category'),
                  cursorColor: Color(0xff2D5C78),
                  onSaved: (value) {},
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          if (!isLoading && !isSubmitted)
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Color(0xffE49D70),
                    shape: StadiumBorder(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Text(
                      isStarted ? 'Post' : 'Start',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111212),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (!isStarted)
                      await getLocation();
                    else {
                      setState(() {
                        isStarted = false;
                      });
                      _sumbit();
                    }
                  }),
            ),
        ],
      ),
    );
  }
}
