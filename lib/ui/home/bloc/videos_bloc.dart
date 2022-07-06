import 'package:nitya/model/post.dart';
import 'package:nitya/repository/base.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

class VideosBloc extends BaseBloc {
  // static final VideosBloc _postBloc = VideosBloc._internal();
  //
  // factory VideosBloc() {
  //   return _postBloc;
  // }
  //
  // VideosBloc._internal();

  final _postStream = BehaviorSubject<PostResponse>();

  Stream<PostResponse> get videos => _postStream.stream;

  int page = 1;

  int _maxPages = 10000;

  Future fetchPosts() async {
    if (page <= (_maxPages / 10).round()) {
      PostResponse posts = await repository.fetchAllPosts(
          AppUtils.currentUser.accessToken, page++, "2");
      _postStream.add(posts);
      _maxPages = posts.total;
    }
    print("Max pages Videos $_maxPages");
  }

  dispose() {
    _postStream.close();
  }
}

final videosBloc = VideosBloc();
