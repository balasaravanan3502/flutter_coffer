import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoData with ChangeNotifier {
  List data = [];

  fetchData() async {
    var user;
    final SharedPreferences sharedpref = await SharedPreferences.getInstance();

    final uid = sharedpref.getString('uid');

    await FirebaseFirestore.instance.collection('users').doc(uid).get().then(
          (value) => {
            user = value,
          },
        );
    if (user.data()['videos'] != null) {
      this.data = user.data()['videos'];
    }

    notifyListeners();
  }
}
