import 'package:flutter/material.dart';
import 'package:nitya/model/post.dart';
import 'package:nitya/ui/common/error_page.dart';
import 'package:nitya/ui/common/loading_page.dart';
import 'package:nitya/ui/common/post_item.dart';
import 'package:nitya/ui/home/bloc/updates_bloc.dart';

// ignore: must_be_immutable
class AllUpdatez extends StatefulWidget {
  UpdatesBloc bloc;

  AllUpdatez(int index) {
    //print("ADD ${this.hashCode}");
    bloc = UpdatesBloc(index);
    print("ADD ${this.bloc.hashCode}");
  }

  @override
  _AllUpdatezState createState() => _AllUpdatezState();
}

class _AllUpdatezState extends State<AllUpdatez> {
  List<Post> allUpdates = [];

  @override
  void didUpdateWidget(covariant AllUpdatez oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadInitilally();
  }

  @override
  void initState() {
    super.initState();
    loadInitilally();
  }

  void loadInitilally() {
    allUpdates.clear();
    widget.bloc.fetchPosts();
    widget.bloc.updates.listen((event) {
      if (event.posts != null) {
        allUpdates.addAll(event.posts);
      }
    });
    doPagination();
    allUpdates.toSet().toList();
  }

  ScrollController scrollController = ScrollController();

  bool isPaginating = false;

  void doPagination() async {
    allUpdates.clear();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        setState(() {
          isPaginating = true;
        });
        widget.bloc.fetchPosts().then((value) {
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
        stream: widget.bloc.updates,
        builder: (context, AsyncSnapshot<PostResponse> snapshot) {
          if (allUpdates.isEmpty) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return ErrorPage(
                  errorMsg: snapshot.data.error,
                  retry: () => widget.bloc.fetchPosts(),
                );
              }
              return RefreshIndicator(
                onRefresh: () => widget.bloc.fetchPosts(),
                child: allUpdates.isEmpty
                    ? LoadingPage("Fetching Posts")
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                                controller: scrollController,
                                shrinkWrap: true,
                                itemBuilder: (_, i) {
                                  return PostItem(allUpdates[i]);
                                },
                                separatorBuilder: (_, __) => Container(
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                itemCount: allUpdates.length),
                          ),
                          if (isPaginating)
                            SizedBox(
                              height: 2,
                              child: LinearProgressIndicator(),
                            )
                        ],
                      ),
              );
            } else if (snapshot.hasError && allUpdates.isEmpty) {
              return ErrorPage(
                errorMsg: snapshot.error,
                retry: () => widget.bloc.fetchPosts(),
              );
            } else {
              return LoadingPage("Fetching Posts");
            }
          } else {
            return RefreshIndicator(
              onRefresh: () => widget.bloc.fetchPosts(),
              child: allUpdates.isEmpty
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
                                return PostItem(allUpdates[i]);
                              },
                              separatorBuilder: (_, __) => Container(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                              itemCount: allUpdates.length),
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
