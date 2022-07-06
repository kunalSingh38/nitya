import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nitya/model/bookmark_model.dart';
import 'package:nitya/ui/bookmark/bloc/bookmark_bloc.dart';
import 'package:nitya/ui/bookmark/bookmark_item.dart';
import 'package:nitya/ui/common/notification_app_bar.dart';
import 'package:nitya/utils/app_utils.dart';

class BookMarks extends StatefulWidget {
  @override
  _BookMarksState createState() => _BookMarksState();
}

class _BookMarksState extends State<BookMarks> {
  @override
  void initState() {
    super.initState();
    bookmarkBloc.bookRemoveStream.listen((event) {
      if (event) {
        AppUtils.showError("Removed from bookmarked", _globalKey);
      } else {
        AppUtils.showError("Couldn't remove from bookmarked", _globalKey);
      }
    });
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  List<BookmarkModel> bookmarks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: PreferredSize(
          child: NotificationAppBar('Bookmarks'),
          preferredSize: Size.fromHeight(56)),
      body: StreamBuilder(
          stream: bookmarkBloc.fetchBookStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<BookmarkModel> bookmarks = snapshot.data;
              print(bookmarks);
              return Container(
                child: bookmarks.isEmpty
                    ? Center(
                        child: Text(
                          "No Bookmarks",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: bookmarks.length,
                        itemBuilder: (_, index) {
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              bookmarkBloc.removeBookmark(
                                  AppUtils.currentUser.accessToken,
                                  bookmarks[index].postId.toString());

                              bookmarks.removeAt(index);
                            },
                            secondaryBackground: Container(
                              padding: EdgeInsets.all(16),
                              alignment: Alignment.centerRight,
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Remove',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              color: Colors.redAccent,
                            ),
                            background: Container(),
                            key: Key(bookmarks[index].bookmarksId.toString()),
                            child: BookMarkItem(bookmarks[index]),
                          );
                        }),
              );
            } else if (snapshot.hasError) {
              return Container(
                child: Center(
                  child: Text(snapshot.error.toString()),
                ),
              );
            } else {
              return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Fetching Bookmarks...",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
