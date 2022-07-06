// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:nitya/model/post.dart';
import 'package:nitya/ui/common/error_page.dart';
import 'package:nitya/ui/common/loading_page.dart';
import 'package:nitya/ui/common/post_item.dart';
import 'package:nitya/ui/home/bloc/all_bloc.dart';
import 'package:nitya/ui/home/bloc/articles_bloc.dart';

class ArticlesPage extends StatefulWidget {
  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  List<Post> allArticles = [];

  ArticlesBLoc articlesBLoc = ArticlesBLoc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FirebaseAnalytics().setCurrentScreen(
    //   screenName: "Article",
    // );
    allArticles.clear();
    articlesBLoc.fetchPosts();
    articlesBLoc.articles.listen((event) {
      if (event.posts != null) {
        allArticles.addAll(event.posts);
      }
    });
    doPagination();
    allArticles.toSet().toList();
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
        articlesBLoc.fetchPosts().then((value) {
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
        stream: articlesBLoc.articles,
        builder: (context, AsyncSnapshot<PostResponse> snapshot) {
          if (allArticles.isEmpty) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return ErrorPage(
                  errorMsg: snapshot.data.error,
                  retry: () => articlesBLoc.fetchPosts(),
                );
              }
              return RefreshIndicator(
                onRefresh: () => articlesBLoc.fetchPosts(),
                child: allArticles.isEmpty
                    ? Container(child: Center(child: Text("No Posts")))
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                                controller: scrollController,
                                shrinkWrap: true,
                                itemBuilder: (_, i) {
                                  return PostItem(allArticles[i]);
                                },
                                separatorBuilder: (_, __) => Container(
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                itemCount: allArticles.length),
                          ),
                          if (isPaginating)
                            const SizedBox(
                              height: 2,
                              child: LinearProgressIndicator(),
                            )
                        ],
                      ),
              );
            } else if (snapshot.hasError && allArticles.isEmpty) {
              return ErrorPage(
                errorMsg: snapshot.error,
                retry: () => articlesBLoc.fetchPosts(),
              );
            } else {
              return LoadingPage("Fetching Posts");
            }
          } else {
            return RefreshIndicator(
              onRefresh: () => articlesBLoc.fetchPosts(),
              child: allArticles.isEmpty
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
                                return PostItem(allArticles[i]);
                              },
                              separatorBuilder: (_, __) => Container(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                              itemCount: allArticles.length),
                        ),
                        if (isPaginating)
                          const SizedBox(
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
