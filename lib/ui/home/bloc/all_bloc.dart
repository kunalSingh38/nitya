import 'package:nitya/model/post.dart';
import 'package:nitya/repository/base.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

class AllPostBloc extends BaseBloc {
  final _postStream = BehaviorSubject<PostResponse>();

  Stream<PostResponse> get allPosts => _postStream.stream;

  int page = 1;

  int _maxPages = 10000;

  Future fetchPosts() async {
    if (page <= (_maxPages / 10).round()) {
      PostResponse posts = await repository.fetchAllPosts(
          AppUtils.currentUser.accessToken, page++, "3");
      _postStream.add(posts);
      _maxPages = posts.total;
    }
    print("Max pages all $_maxPages");
  }

  dispose() {
    _postStream.close();
  }
}

final allPostBloc = AllPostBloc();
