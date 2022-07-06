import 'package:nitya/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class ResendBloc extends BaseBloc {
  final _resendOtpStream = PublishSubject<String>();
  final _errorStream = PublishSubject<String>();
  final _loadingStream = PublishSubject<bool>();

  Stream<String> get resendStream => _resendOtpStream.stream;

  Stream<bool> get loadingStream => _loadingStream.stream;

  Stream<String> get errorStream => _errorStream.stream;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _resendOtpStream?.close();
    _errorStream?.close();
    _loadingStream?.close();
  }

  void resendOtp(String phone, int isPhoneVerified) async {
    if (isLoading) return;

    isLoading = true;
    _loadingStream.sink.add(isLoading);
    await repository.resendOTP(isPhoneVerified, phone).then((value) {
      isLoading = false;
      _loadingStream.sink.add(isLoading);
      _resendOtpStream.sink.add(value);
    });
  }
}
