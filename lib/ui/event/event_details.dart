import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:nitya/model/event.dart';
import 'package:nitya/ui/common/notification_app_bar.dart';
import 'package:nitya/ui/post/post_detail_page.dart';
import 'package:nitya/utils/constants.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EventDetails extends StatefulWidget {
  final EventModel event;

  EventDetails(this.event);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String videoId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // createDynamicLink(widget.event);

    if (widget.event.urlType == 1) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.event.url),
        flags: YoutubePlayerFlags(
          autoPlay: false,
        ),
      );
    }
  }

  YoutubePlayerController _controller;

  var unescape = new HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
        ),
        builder: (context, player) {
          return Scaffold(
            bottomNavigationBar: Container(
              margin: EdgeInsets.all(16),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                color: kPrimaryColor,
                onPressed: () {
                  lunchUrl(widget.event.registrationLink);
                },
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (widget.event.urlType == 1) player,
                  if (widget.event.urlType != 1)
                    Hero(
                      tag: widget.event.id,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: CachedNetworkImage(
                          imageUrl: widget.event.url,
                          placeholder: (context, url) => Container(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                                height: 2, child: LinearProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          height: 196,
                          width: double.maxFinite,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  Container(
                    padding: EdgeInsets.only(top: 8, right: 16, left: 16),
                    child: Text(
                      widget.event.timestamp,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "${widget.event.title}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.share, color: kPrimaryColor),
                          onPressed: () {
                            // if (url != null)
                            //   Share.share(
                            //       "${widget.event.title}\n\nDownload NITYA Tax Associates app to register for the webinar ${url.shortUrl}",
                            //       subject: '${widget.event.title}');
                          })
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: HtmlWidget(
                      "${unescape.convert(widget.event.description)}",
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
                  (widget.event.pdftitle == null || widget.event.pdftitle == "")
                      ? Container(
                          height: 0,
                        )
                      : Container(
                          padding: EdgeInsets.all(16),
                          child: InkWell(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (_) => PdfViewer(widget.event.pdftitle,
                              //             widget.event.pdffile)));

                              lunchUrl(widget.event.pdffile);
                            },
                            child: Text(
                              widget.event.pdftitle,
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
                  // Visibility(
                  //   visible: widget.event.pdftitle != null,
                  //   child: Container(
                  //     padding: EdgeInsets.all(16),
                  //     child: InkWell(
                  //       onTap: () {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (_) => PdfViewer(widget.event.pdftitle,
                  //                     widget.event.pdffile)));
                  //       },
                  //       child: Text(
                  //         "${widget.event.pdftitle}",
                  //         style: TextStyle(
                  //           color: kPrimaryColor,
                  //           fontStyle: FontStyle.italic,
                  //           decoration: TextDecoration.underline,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            appBar: PreferredSize(
              child: NotificationAppBar("Events"),
              preferredSize: Size.fromHeight(56),
            ),
          );
        });
  }

  // ShortDynamicLink url;

  var unsecape = HtmlUnescape();

  // createDynamicLink(EventModel event) async {
  //   final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
  //     uriPrefix: "https://nityataxassociates.page.link",
  //     socialMetaTagParameters: SocialMetaTagParameters(
  //       imageUrl: Uri.parse(
  //         "${event.url}",
  //       ),
  //       description: unescape.convert("${event.description}"),
  //       title: event.title,
  //     ),
  //     link: Uri.parse(
  //         "https://nityataxassociates.page.link/event?id=${widget.event.id}"),
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
  //     setState(() {
  //       url = value;
  //     });
  //   });
  // }
}
