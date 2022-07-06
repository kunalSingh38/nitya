import 'package:dio/dio.dart';
import 'package:nitya/model/query.dart';
import 'package:nitya/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class QueryBloc extends BaseBloc {
  final _querySubject = PublishSubject<bool>();
  final _loadingSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<DioError>();

  Stream<bool> get queryStream => _querySubject.stream;

  Stream<bool> get loadingStream => _loadingSubject.stream;

  Stream<DioError> get errorStream => _errorSubject.stream;

  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _errorSubject?.close();
    _loadingSubject?.close();
    _querySubject?.close();
  }

  void postQuery(Query query) async {
    if (isLoading) return;

    isLoading = true;
    _loadingSubject.sink.add(isLoading);

    await repository.postQuery(query).then((value) {
      isLoading = false;
      _loadingSubject.sink.add(isLoading);
      _querySubject.sink.add(value);
    }).catchError((e) {
      isLoading = false;
      _loadingSubject.sink.add(isLoading);
      _errorSubject.sink.add(e);
    });
  }
}
