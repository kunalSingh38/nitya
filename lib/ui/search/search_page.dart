import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nitya/model/event.dart';
import 'package:nitya/model/search.dart';
import 'package:nitya/ui/event/event_details.dart';
import 'package:nitya/ui/feedback/feedback_page.dart';
import 'package:nitya/ui/post/post_detail_page.dart';
import 'package:nitya/ui/search/bloc/search_bloc.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:nitya/utils/constants.dart';

import '../../model/post.dart' as p;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchBloc _bloc = SearchBloc();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.searchStream.listen((event) {
      setState(() {
        posts = event ?? [];
      });
    });
    _bloc.loadingStream.listen((event) {
      setState(() {
        isSearching = event;
      });
    });

    _bloc.errorStream.listen((event) {
      setState(() {
        isSearching = false;
      });
      AppUtils.showError(event, key);
    });
  }

  bool isSearching = false;

  List<Search> posts = [];

  GlobalKey<ScaffoldState> key = GlobalKey();

  final FocusNode node = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isSearching
                ? SizedBox(
                    height: 3,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    ),
                  )
                : Container(),
            _controller.text.isEmpty
                ? ListTile(
                    onTap: () => FocusScope.of(context).requestFocus(node),
                    title: Text("Tap here to search"),
                  )
                : Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Result(s)",
                          style: TextStyle(fontSize: 16),
                        ),
                        posts.length == 0
                            ? Text("No Results")
                            : ScrollConfiguration(
                                behavior: MyBehavior(),
                                child: ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: posts.length,
                                    itemBuilder: (_, index) {
                                      return ListTile(
                                        onTap: () {
                                          if (posts[index].postType == 3) {
                                            //its event
                                            Search e = posts[index];
                                            EventModel event = EventModel(
                                                id: e.eventsId,
                                                title: e.title,
                                                bookmarkedBy: e.bookmarkedBy,
                                                description: e.description,
                                                postType: e.postType,
                                                registrationLink:
                                                    e.registrationLink,
                                                timestamp: e.timestamp,
                                                urlType: e.urlType,
                                                url: e.url);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        EventDetails(event)));
                                          } else {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (_) => PostDetails(
                                            //             p.Post.fromJson(
                                            //                 posts[index]
                                            //                     .toJson()))));
                                            print(posts[index].toJson());
                                          }
                                        },
                                        contentPadding: EdgeInsets.all(0),
                                        trailing: Text(
                                          AppUtils.getPostTypeByCode(
                                            posts[index].postType,
                                          ),
                                          style:
                                              TextStyle(color: kPrimaryColor),
                                        ),
                                        title: Text(
                                          posts[index].title,
                                          maxLines: 1,
                                        ),
                                      );
                                    }),
                              ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
      appBar: PreferredSize(
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.shade100),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: node,
                          controller: _controller,
                          onChanged: (k) {
                            if (k.length > 2) {
                              posts.clear();
                              _bloc.search(k, AppUtils.currentUser.accessToken);
                            }
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: "Search",
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            color: kPrimaryColor,
          ),
          preferredSize: Size.fromHeight(48)),
    );
  }
}
