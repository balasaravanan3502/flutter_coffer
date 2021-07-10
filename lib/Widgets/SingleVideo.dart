import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class SingleVideo extends StatelessWidget {
  dynamic data;
  SingleVideo(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BetterPlayer.network(data['link']),
          SizedBox(
            height: MediaQuery.of(context).size.height * .05,
          ),
          Column(
            children: [
              Text(
                data['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.thumb_up,
                  ),
                  Icon(
                    Icons.thumb_down,
                  ),
                  Icon(
                    Icons.share,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Views : ${data['views']}',
                  ),
                  Text(
                    'Days : ${data['days']}',
                  ),
                  Text(
                    'Category : ${data['category']}',
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Reply',
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
