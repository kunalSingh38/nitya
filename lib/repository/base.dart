import 'package:nitya/repository/repo.dart';

abstract class BaseBloc {
  final repository = Repository();

  void dispose() {}
}
