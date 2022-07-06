import 'package:nitya/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc extends BaseBloc {
  final _profileUpdateStream = PublishSubject<dynamic>();
  final _loadingStream = PublishSubject<bool>();
  final _errorStream = PublishSubject<String>();

  Stream<dynamic> get profileStream => _profileUpdateStream.stream;

  Stream<bool> get loadingStream => _loadingStream.stream;

  Stream<String> get errorStream => _errorStream.stream;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _profileUpdateStream?.close();
    _loadingStream?.close();
    _errorStream?.close();
  }

  void updateProfile(
      email, phoneNo, name, accessToken, org, designation) async {
    if (isLoading) return;
    isLoading = true;
    _loadingStream.sink.add(true);

    await repository
        .updateUser(accessToken, name, email, phoneNo, org, designation)
        .then((value) {
      print(value);
      isLoading = false;
      _loadingStream.sink.add(isLoading);
      _profileUpdateStream.sink.add(value);
    }).catchError((error) {
      isLoading = false;
      _loadingStream.sink.add(isLoading);
      _errorStream.add(error.toString());
    });
  }
}
