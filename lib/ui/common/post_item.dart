import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nitya/model/post.dart';
import 'package:nitya/ui/event/chew_video_player.dart';
import 'package:nitya/ui/post/post_detail_page.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:nitya/utils/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PostItem extends StatelessWidget {
  final Post post;

  PostItem(this.post);

  final List<String> categories = <String>[
    'Compliance Calender',
    'Insight',
    'Legal Precedents Series',
    'Outlook'
  ];

  @override
  Widget build(BuildContext context) {
    String videoId;

    if (post.postType == VIDEO) {
      // videoId = YoutubePlayer.convertUrlToId(post.url);
    }
    print(videoId); // BBAyRBTfsOU
    return ListTile(
      onTap: () => Navigator.push(
          context, CupertinoPageRoute(builder: (_) => PostDetails(post))),
      title: Text(
        AppUtils.parseHtmlString(post.title),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Hero(
        tag: post.id.toString(),
        child: Container(
          color: Colors.grey.shade200,
          width: 96,
          child: Container(
            height: 124,
            width: 96,
            color: Colors.grey.shade200,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: post.postType == VIDEO
                      ? "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(post.url)}/default.jpg"
                      : post.url,
                  placeholder: (context, url) => Container(
                    alignment: Alignment.bottomCenter,
                    child:
                        SizedBox(height: 2, child: LinearProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  height: 196,
                  width: 96,
                  fit: BoxFit.fill,
                ),
                if (post.postType == VIDEO)
                  Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                if (post.postType == VIDEO)
                  Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
              ],
            ),
          ),
        ),
        // ),
      ),
      subtitle: GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(maxWidth: 124),
                child: Text(
                  post.postType == 0
                      ? post.category <= 3
                          ? categories[post.category - 1]
                          : categories[3]
                      : AppUtils.getPostTypeByCode(post.postType),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              Text(
                post.postDate,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
