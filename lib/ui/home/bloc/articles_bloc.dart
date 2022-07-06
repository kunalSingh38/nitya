import 'package:nitya/model/post.dart';
import 'package:nitya/repository/base.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

class ArticlesBLoc extends BaseBloc {
  // static final ArticlesBLoc _postBloc = ArticlesBLoc._internal();
  //
  // factory ArticlesBLoc() {
  //   return _postBloc;
  // }
  //
  // ArticlesBLoc._internal();

  final _postStream = BehaviorSubject<PostResponse>();

  Stream<PostResponse> get articles => _postStream.stream;
  int page = 1;

  int _maxPages = 10000;

  Future fetchPosts() async {
    if (page <= (_maxPages / 10).round()) {
      PostResponse posts = await repository.fetchAllPosts(
          AppUtils.currentUser.accessToken, page++, "1");
      _postStream.add(posts);
      _maxPages = posts.total;
    }
    print("Max pages updates $_maxPages");
  }

  dispose() {
    _postStream.close();
  }
}

final articlesBLoc = ArticlesBLoc();
