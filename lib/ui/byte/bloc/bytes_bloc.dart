import 'package:nitya/model/bytes_model.dart';
import 'package:nitya/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class ByteBloc extends BaseBloc {
  static final ByteBloc _byteBloc = ByteBloc._internal();

  factory ByteBloc() {
    return _byteBloc;
  }

  ByteBloc._internal();

  final _byteStream = BehaviorSubject<ByteResponse>();

  Stream<ByteResponse> get bytes => _byteStream.stream;

  fetchBytes(String accessToken) async {
    ByteResponse bytes = await repository.fetchBytes(accessToken);
    _byteStream.sink.add(bytes);
  }

  dispose() {
    _byteStream.close();
  }
}

final bytesBloc = ByteBloc();
