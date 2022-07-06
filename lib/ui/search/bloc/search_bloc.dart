import 'package:nitya/model/search.dart';
import 'package:nitya/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends BaseBloc {
  final _searchStream = PublishSubject<List<Search>>();
  final _loadingSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<String>();

  Stream<List<Search>> get searchStream => _searchStream.stream;

  Stream<bool> get loadingStream => _loadingSubject.stream;

  Stream<String> get errorStream => _errorSubject.stream;

  search(String key, String accessToken) async {
    _loadingSubject.sink.add(true);
    repository.search(key, accessToken).catchError((e) {
      _loadingSubject.sink.add(false);
      _errorSubject.sink.add(e.toString());
    }).then((value) {
      _loadingSubject.sink.add(false);
      _searchStream.sink.add(value);
    });
  }

  dispose() {
    _searchStream.close();
    _loadingSubject?.close();
    _errorSubject?.close();
  }
}

final searchStream = SearchBloc();
