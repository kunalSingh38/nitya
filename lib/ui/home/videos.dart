import 'package:flutter/material.dart';
import 'package:nitya/model/post.dart';
import 'package:nitya/ui/common/error_page.dart';
import 'package:nitya/ui/common/loading_page.dart';
import 'package:nitya/ui/common/post_item.dart';
import 'package:nitya/ui/home/bloc/videos_bloc.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<Post> allVideos = [];

  VideosBloc videosBloc = VideosBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videosBloc.fetchPosts();
    videosBloc.videos.listen((event) {
      if (event.posts != null) {
        allVideos.addAll(event.posts);
      }
    });
    doPagination();
    allVideos.toSet().toList();
  }

  ScrollController scrollController = ScrollController();

  bool isPaginating = false;

  void doPagination() async {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        setState(() {
          isPaginating = true;
        });
        videosBloc.fetchPosts().then((value) {
          if (mounted)
            setState(() {
              isPaginating = false;
            });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<PostResponse>(
        stream: videosBloc.videos,
        builder: (context, AsyncSnapshot<PostResponse> snapshot) {
          if (allVideos.isEmpty) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return ErrorPage(
                  errorMsg: snapshot.data.error,
                  retry: () => videosBloc.fetchPosts(),
                );
              }
              return RefreshIndicator(
                onRefresh: () => videosBloc.fetchPosts(),
                child: allVideos.isEmpty
                    ? Container(
                        child: Center(child: Text("No Posts")),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                                controller: scrollController,
                                shrinkWrap: true,
                                itemBuilder: (_, i) {
                                  return PostItem(allVideos[i]);
                                },
                                separatorBuilder: (_, __) => Container(
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                itemCount: allVideos.length),
                          ),
                          if (isPaginating)
                            SizedBox(
                              height: 2,
                              child: LinearProgressIndicator(),
                            )
                        ],
                      ),
              );
            } else if (snapshot.hasError && allVideos.isEmpty) {
              return ErrorPage(
                errorMsg: snapshot.error,
                retry: () => videosBloc.fetchPosts(),
              );
            } else {
              return LoadingPage("Fetching Posts");
            }
          } else {
            return RefreshIndicator(
              onRefresh: () => videosBloc.fetchPosts(),
              child: allVideos.isEmpty
                  ? Container(
                      child: Center(child: Text("No Posts")),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              controller: scrollController,
                              shrinkWrap: true,
                              itemBuilder: (_, i) {
                                return PostItem(allVideos[i]);
                              },
                              separatorBuilder: (_, __) => Container(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                              itemCount: allVideos.length),
                        ),
                        if (isPaginating)
                          SizedBox(
                            height: 2,
                            child: LinearProgressIndicator(),
                          )
                      ],
                    ),
            );
          }
        },
      ),
    );
  }
}
