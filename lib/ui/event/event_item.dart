import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nitya/model/event.dart';
import 'package:nitya/ui/event/chew_video_player.dart';
import 'package:nitya/ui/event/event_details.dart';
import 'package:nitya/ui/video_player.dart';

class EventItem extends StatelessWidget {
  final EventModel event;

  EventItem(this.event);

  @override
  Widget build(BuildContext context) {
    String videoId;

    if (event.urlType == 1) {
      // videoId = YoutubePlayer.convertUrlToId(event.url);
    }
    return ListTile(
      onTap: () => Navigator.push(
          context, CupertinoPageRoute(builder: (_) => EventDetails(event))),
      title: Text(
        event.title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Hero(
        tag: event.id,
        child: Container(
          width: 96,
          child: event.urlType == 1
              ? Container(
                  color: Colors.grey.shade200,
                  child: FittedBox(
                      child: videoId == null
                          ? ChewVideoPlayer(event.url, true)
                          : VideoPlayer(
                              url: event.url,
                            )))
              : Container(
                  height: 124,
                  width: 96,
                  color: Colors.grey.shade200,
                  child: CachedNetworkImage(
                    imageUrl: event.url,
                    placeholder: (context, url) => Container(
                      alignment: Alignment.bottomCenter,
                      child:
                          SizedBox(height: 2, child: LinearProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: 196,
                    fit: BoxFit.fill,
                  ),
                ),
        ),
      ),
      subtitle: GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Event",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              Text(
                event.timestamp,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
