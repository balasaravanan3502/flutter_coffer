import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_coffer/Provider/VideoData.dart';
import 'package:flutter_task_coffer/Widgets/SingleVideo.dart';
import 'package:flutter_task_coffer/Widgets/VideoCard.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'AddScreen.dart';
import 'LibraryScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int videoSelected = -1;

  String value = '';
  List _screens = <Widget>[AddScreen(), LibraryScreen()];

  List data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search_sharp),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff2D5C78),
        onTap: (index) {
          setState(
            () {
              _selectedIndex = index;
              if (_selectedIndex == 0) {
                videoSelected = -1;
              }
            },
          );
        },
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: _selectedIndex == 0
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        onChanged: (text) {
                          setState(() {
                            value = text;
                          });
                        },
                        decoration:
                            kTextFieldDecoration.copyWith(hintText: 'Search'),
                        cursorColor: Color(0xff2D5C78),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {},
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    if (videoSelected == -1)
                      Flexible(
                        child: Consumer<VideoData>(
                          builder: (context, video, child) {
                            data = video.data;

                            return ListView.builder(
                                itemCount: video.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (video.data[index]['title']
                                      .toString()
                                      .startsWith(value))
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          videoSelected = index;
                                        });
                                      },
                                      child: VideoCard(video.data[index]),
                                    );
                                  else
                                    return Container();
                                });
                          },
                        ),
                      ),
                    if (videoSelected != -1) SingleVideo(data[videoSelected]),
                  ],
                )
              : _screens[_selectedIndex - 1],
        ),
      ),
    );
  }
}
