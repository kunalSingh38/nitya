import 'package:flutter/material.dart';
import 'package:nitya/model/post.dart';
import 'package:nitya/ui/common/error_page.dart';
import 'package:nitya/ui/common/loading_page.dart';
import 'package:nitya/ui/common/post_item.dart';
import 'package:nitya/ui/home/bloc/all_bloc.dart';

class AllPosts extends StatefulWidget {
  @override
  _AllPostsState createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  List<Post> allPosts = [];

  AllPostBloc allPostBloc = AllPostBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allPosts.clear();
    allPostBloc.fetchPosts();
    allPostBloc.allPosts.listen((event) {
      if (event.posts != null) {
        allPosts.addAll(event.posts);
      }
    });
    doPagination();
    allPosts.toSet().toList();
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
        allPostBloc.fetchPosts().then((value) {
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
        stream: allPostBloc.allPosts,
        builder: (context, AsyncSnapshot<PostResponse> snapshot) {
          if (allPosts.isEmpty) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return ErrorPage(
                  errorMsg: snapshot.data.error,
                  retry: () => allPostBloc.fetchPosts(),
                );
              }
              return RefreshIndicator(
                onRefresh: () => allPostBloc.fetchPosts(),
                child: allPosts.isEmpty
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
                                  return PostItem(allPosts[i]);
                                },
                                separatorBuilder: (_, __) => Container(
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                itemCount: allPosts.length),
                          ),
                          if (isPaginating)
                            SizedBox(
                              height: 2,
                              child: LinearProgressIndicator(),
                            )
                        ],
                      ),
              );
            } else if (snapshot.hasError && allPosts.isEmpty) {
              return ErrorPage(
                errorMsg: snapshot.error,
                retry: () => allPostBloc.fetchPosts(),
              );
            } else {
              return LoadingPage("Fetching Posts");
            }
          } else {
            return RefreshIndicator(
              onRefresh: () => allPostBloc.fetchPosts(),
              child: allPosts.isEmpty
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
                                return PostItem(allPosts[i]);
                              },
                              separatorBuilder: (_, __) => Container(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                              itemCount: allPosts.length),
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
