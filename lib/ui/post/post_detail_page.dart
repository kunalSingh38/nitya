import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:nitya/model/post.dart';
import 'package:nitya/ui/bookmark/bloc/bookmark_bloc.dart';
import 'package:nitya/ui/common/notification_app_bar.dart';
import 'package:nitya/ui/feedback/feedback_page.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:nitya/utils/constants.dart';
import 'package:nitya/utils/image_helper.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PostDetails extends StatefulWidget {
  final Post post;

  PostDetails(this.post);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  bool _isBooked = false;
  double progress = 0;
  BookmarkBloc _bloc = BookmarkBloc();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  var unescape = new HtmlUnescape();
  String videoId;

  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    //createDynamicLink(widget.post);
    if (widget.post.bookmarkedBy.contains(AppUtils.currentUser.userId.toString())) {
      if (mounted)
        setState(() {
          _isBooked = true;
        });
    }
    _bloc.bookAddStream.listen((event) {
      if (event) {
        AppUtils.showError("Added to bookmarked", _globalKey);
      }
    });

    _bloc.bookErrorAddStream.listen((event) {
      AppUtils.showError(event, _globalKey);
    });

    _bloc.bookRemoveStream.listen((event) {
      if (event) {
        AppUtils.showError("Removed from bookmarked", _globalKey);
      }
    });

    if (widget.post.postType == VIDEO) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.post.url),
        flags: YoutubePlayerFlags(
          autoPlay: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        return true;
      },
      child: YoutubePlayerBuilder(
        builder: (context, player) {
          return Scaffold(
            key: _globalKey,
            body: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // ? VideoPlayer(
                      //     url: widget.post.url,
                      //   )
                      if (widget.post.postType == VIDEO) player,
                      if (widget.post.postType != VIDEO)
                        CachedNetworkImage(
                          imageUrl: widget.post.postType == VIDEO
                              ? "https://img.youtube.com/vi/$videoId/hqdefault.jpg"
                              : widget.post.url,
                          placeholder: (context, url) => Container(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                                height: 2, child: LinearProgressIndicator()),
                          ),
                          width: double.maxFinite,
                          height: 196,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.fill,
                        ),
                      Container(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                          child: Text(
                            widget.post.timestamp,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade500),
                          )),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppUtils.parseHtmlString(
                                    "${widget.post.title}"),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ),
                            IconButton(
                                icon: Icon(
                                  _isBooked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: _isBooked ? kPrimaryColor : kDarkColor,
                                ),
                                onPressed: () {
                                  if (_isBooked) {
                                    _bloc.removeBookmark(
                                        AppUtils.currentUser.accessToken,
                                        widget.post.id.toString());
                                  } else {
                                    _bloc.addBookmark(
                                        AppUtils.currentUser.accessToken,
                                        widget.post.id.toString());
                                  }
                                  setState(() {
                                    _isBooked = !_isBooked;
                                  });
                                }),
                            IconButton(
                                icon: Icon(Icons.share, color: kPrimaryColor),
                                onPressed: () async{
                                  await FlutterShare.share(
                                      title: widget.post.title.toString(),
                                      text: widget.post.title.toString()+'\n\nDownload NITYA Tax Associates App to read more',
                                      linkUrl: 'https://play.google.com/store/apps/details?id=com.entrepreter.nityaassociation\n\nhttps://apps.apple.com/in/app/nitya-tax-associates/id1552181161',
                                      chooserTitle: '');
                                  // if (url != null)
                                  //   Share.share("${widget.post.title}\n\nDownload NITYA Tax Associates App to read more ${url.shortUrl}", subject: "${widget.post.title}");
                                })
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: HtmlWidget(
                          "${unescape.convert(widget.post.description)}",
                          customStylesBuilder: (element) {
                            return {'text-align': 'justify'};
                          },
                          customWidgetBuilder: (element) {
                            return null;
                          },

                          // this callback will be triggered when user taps a link
                          onTapUrl: (url) => lunchUrl(url),

                          // set the default styling for text
                          textStyle: TextStyle(fontSize: 14),
                        ),
                      ),
                      if (widget.post.pdftitle != null &&
                          widget.post.pdftitle != "" &&
                          widget.post.pdffile != null &&
                          widget.post.pdffile != "")
                        Container(
                          padding: EdgeInsets.all(16),
                          child: InkWell(
                            onTap: () => lunchUrl(widget.post.pdffile),
                            child: Text(
                              "${widget.post.pdftitle}",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              mini: true,
              elevation: 1,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => FeedbackPage(
                              title: widget.post.title,
                              id: widget.post.id,
                            )));
              },
              child: SvgPicture.asset(
                QUERY_ICON,
                color: kPrimaryColor,
                height: 18,
              ),
            ),
            appBar: PreferredSize(
              child: NotificationAppBar(
                  AppUtils.getPostTypeByCode(widget.post.postType)),
              preferredSize: Size.fromHeight(56),
            ),
          );
        },
        player: YoutubePlayer(
          controller: _controller,
        ),
      ),
    );
  }

  //ShortDynamicLink url;
  ShortDynamicLink url;
  // createDynamicLink(Post post) async{
  //   final dynamicLinkParams = DynamicLinkParameters(
  //     link: Uri.parse("https://nityataxassociates.page.link/post?id=${widget.post.id}"),
  //     uriPrefix: "https://nityataxassociates.page.link",
  //     androidParameters: const AndroidParameters(
  //       packageName: "com.entrepreter.nityaassociation",
  //       minimumVersion: 30,
  //     ),
  //     iosParameters: const IOSParameters(
  //       bundleId: 'com.adsandurl.nta',
  //       minimumVersion: '1.0.1',
  //       appStoreId: '1552181161',
  //     ),
  //     socialMetaTagParameters: SocialMetaTagParameters(
  //       title: post.title,
  //       imageUrl: Uri.parse("${post.url}"),
  //     ),
  //   );
  //   final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
  //   setState(() {
  //     url = dynamicLink;
  //   });
  // }

  // createDynamicLink(Post post) async {
  //   print("calling this");
  //   final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
  //     uriPrefix: "https://nityataxassociates.page.link",
  //     socialMetaTagParameters: SocialMetaTagParameters(
  //       imageUrl: Uri.parse("${post.url}"),
  //       description: unescape.convert("${post.description}"),
  //       title: post.title,
  //     ),
  //     link: Uri.parse("https://nityataxassociates.page.link/post?id=${widget.post.id}"),
  //     iosParameters: IosParameters(
  //       bundleId: 'com.adsandurl.nta',
  //       minimumVersion: '1.0.1',
  //       appStoreId: '1552181161',
  //     ),
  //     androidParameters: AndroidParameters(
  //       packageName: "com.entrepreter.nityaassociation",
  //     ),
  //   );
  //   dynamicLinkParameters.buildShortLink().then((value) {
  //      setState(() {
  //          url = value;
  //      });
  //      print(url);
  //    });
  // }
}

lunchUrl(String url) async {
  try {
    await launch(Uri.encodeFull(url));
  } catch (e, stacktrace) {
    print("error launcing url $e");
    debugPrint("$stacktrace");
  }
}
