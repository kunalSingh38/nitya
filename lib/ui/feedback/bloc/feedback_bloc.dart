import 'package:dio/dio.dart';
import 'package:nitya/model/feedback.dart';
import 'package:nitya/model/query.dart';
import 'package:nitya/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class FeedbackBloc extends BaseBloc {
  final _feedbackSubject = PublishSubject<bool>();
  final _loadingSubject = PublishSubject<bool>();
  final _errorSubject = PublishSubject<DioError>();

  Stream<bool> get feedbackStream => _feedbackSubject.stream;

  Stream<bool> get loadingStream => _loadingSubject.stream;

  Stream<DioError> get errorStream => _errorSubject.stream;

  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _errorSubject?.close();
    _loadingSubject?.close();
    _feedbackSubject?.close();
  }

  void postFeedback(Feedback feedback) async {
    if (isLoading) return;

    isLoading = true;
    _loadingSubject.sink.add(isLoading);

    await repository.postFeedback(feedback).then((value) {
      isLoading = false;
      _loadingSubject.sink.add(isLoading);
      _feedbackSubject.sink.add(value);
    }).catchError((e) {
      isLoading = false;
      _loadingSubject.sink.add(isLoading);
      _errorSubject.sink.add(e);
    });
  }
}
