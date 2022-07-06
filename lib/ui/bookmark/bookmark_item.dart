import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nitya/model/bookmark_model.dart';
import 'package:nitya/ui/event/chew_video_player.dart';
import 'package:nitya/ui/post/post_detail_page.dart';
import 'package:nitya/ui/video_player.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:nitya/utils/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BookMarkItem extends StatelessWidget {
  final BookmarkModel _bookmarkModel;

  BookMarkItem(this._bookmarkModel);

  @override
  Widget build(BuildContext context) {
    String videoId;

    if (_bookmarkModel.post.postType == VIDEO) {
      // videoId = YoutubePlayer.convertUrlToId(_bookmarkModel.post.url);
    }
    return Container(
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PostDetails(_bookmarkModel.post)));
        },
        title: Text(
          _bookmarkModel.post.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          AppUtils.getPostTypeByCode(_bookmarkModel.post.postType),
          style: TextStyle(color: kPrimaryColor),
        ),
        trailing: Hero(
          tag: _bookmarkModel..toString(),
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
                    imageUrl: _bookmarkModel.post.postType == VIDEO
                        ? "https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(_bookmarkModel.post.url)}/default.jpg"
                        : _bookmarkModel.post.url,
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
                  if (_bookmarkModel.post.postType == VIDEO)
                    Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  if (_bookmarkModel.post.postType == VIDEO)
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
        ),
      ),
    );
  }
}
