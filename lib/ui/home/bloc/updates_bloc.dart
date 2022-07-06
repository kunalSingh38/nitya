import 'package:nitya/model/post.dart';
import 'package:nitya/repository/base.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

class UpdatesBloc extends BaseBloc {
  final int filter;
  UpdatesBloc(this.filter);

  final _postStream = BehaviorSubject<PostResponse>();

  Stream<PostResponse> get updates => _postStream.stream;

  int page = 1;

  int _maxPages = 10000;

  Future fetchPosts() async {
    if (page <= (_maxPages / 10).round()) {
      PostResponse posts = await repository.fetchUpdates(
          AppUtils.currentUser.accessToken, page++, filter.toString());
      _postStream.add(posts);
      _maxPages = posts.total;
    }
    print("Max pages updates$_maxPages");
  }

  dispose() {
    _postStream.close();
  }
}

/*final allUpdatesBloc = UpdatesBloc(0);
final compilanceBloc = UpdatesBloc(1);
final insightBloc = UpdatesBloc(2);
final legalBloc = UpdatesBloc(3);
final outlookBloc = UpdatesBloc(4);*/
