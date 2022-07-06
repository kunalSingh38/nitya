import 'package:nitya/model/error_model.dart';
import 'package:nitya/model/new_signup_model.dart';
import 'package:nitya/model/sign_model.dart';
import 'package:nitya/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends BaseBloc {
  final _signUpStream = PublishSubject<SignUpModel>();
  final _loadingStream = PublishSubject<bool>();
  final _errorStream = PublishSubject<Error>();

  Stream<SignUpModel> get signUpStream => _signUpStream.stream;

  Stream<bool> get loadingStream => _loadingStream.stream;

  Stream<Error> get errorStream => _errorStream.stream;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _signUpStream?.close();
    _loadingStream?.close();
    _errorStream?.close();
  }

  void signUp(
      {String name,
      String countryCode,
      String phone,
      email,
      String fcmToken}) async {
    print("calling");
    if (isLoading) return;
    isLoading = true;
    _loadingStream.sink.add(true);
    SignUpModel r =
        await repository.signUp(name, countryCode, phone, email, fcmToken);
    isLoading = false;
    _loadingStream.sink.add(isLoading);
    _signUpStream.sink.add(r);

//       .then((value) {
//      print(value);
//      isLoading = false;
//      _loadingStream.sink.add(isLoading);
//      _signUpStream.sink.add(User.fromJson(value['user']));
//    }).catchError((error) {
//      isLoading = false;
//      _loadingStream.sink.add(isLoading);
//      _errorStream.add(Error.fromJson(error));
//    });
  }
}
