import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_coffer/Provider/VideoData.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/HomeScreen.dart';
import 'Screens/LoginScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: VideoData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter',
        home: LandingScreen(),
      ),
    );
  }
}

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  Future<String> landingPageDecider() async {
    var logindata = await SharedPreferences.getInstance();

    if (logindata.getString('uid') != null) {
      final provider = Provider.of<VideoData>(context, listen: false);
      provider.fetchData();
      return 'home';
    }
    return 'signIn';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: landingPageDecider(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data == 'home') return HomeScreen();

          return LoginScreen();
        });
  }
}
