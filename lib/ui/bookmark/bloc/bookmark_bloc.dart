import 'package:nitya/model/bookmark_model.dart';
import 'package:nitya/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class BookmarkBloc extends BaseBloc {
  static final BookmarkBloc _bookmarkBloc = BookmarkBloc._internal();

  factory BookmarkBloc() {
    return _bookmarkBloc;
  }

  BookmarkBloc._internal();

  var _bookmarkAddSubject = PublishSubject<bool>();
  var _bookmarkErrorSubject = PublishSubject<String>();
  var _bookmarkRemoveSubject = PublishSubject<bool>();
  var _fetchBookmarkSubject = BehaviorSubject<List<BookmarkModel>>();

  Stream<bool> get bookAddStream => _bookmarkAddSubject.stream;

  Stream<String> get bookErrorAddStream => _bookmarkErrorSubject.stream;

  Stream<bool> get bookRemoveStream => _bookmarkRemoveSubject.stream;

  Stream<List<BookmarkModel>> get fetchBookStream =>
      _fetchBookmarkSubject.stream;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bookmarkAddSubject?.close();
    _bookmarkErrorSubject?.close();
    _fetchBookmarkSubject?.close();
    _bookmarkRemoveSubject?.close();
  }

  ///TODO postbloc. fetch Posts
  void addBookmark(String accessToken, String postId) async {
    await repository.addBookmark(accessToken, postId).then((value) {
      _bookmarkAddSubject.sink.add(value);
      fetchBookmarks(accessToken);
      // PostBloc().fetchPosts(accessToken);
    }).catchError((e) {
      _bookmarkErrorSubject.sink.add(e);
    });
  }

  void removeBookmark(String accessToken, String postId) async {
    await repository.removeBookmark(accessToken, postId).then((value) {
      _bookmarkRemoveSubject.sink.add(value);
      fetchBookmarks(accessToken);
      //update posts
      // .fetchPosts(accessToken);
    });
  }

  void fetchBookmarks(String accessToken) async {
    await repository.fetchBookmarks(accessToken).then((value) {
      _fetchBookmarkSubject.sink.add(value);
    });
  }
}

final BookmarkBloc bookmarkBloc = BookmarkBloc();
