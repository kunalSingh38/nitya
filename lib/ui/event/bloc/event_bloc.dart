import 'package:nitya/model/event.dart';
import 'package:nitya/repository/base.dart';
import 'package:rxdart/rxdart.dart';

class EventBloc extends BaseBloc {
  static final EventBloc _eventBloc = EventBloc._internal();

  factory EventBloc() {
    return _eventBloc;
  }

  EventBloc._internal();

  final _eventStream = BehaviorSubject<EventResponse>();

  Stream<EventResponse> get events => _eventStream.stream;

  fetchEvents(String accessToken) async {
    EventResponse events = await repository.fetchEvents(accessToken);
    _eventStream.sink.add(events);
  }

  dispose() {
    _eventStream.close();
  }
}

final eventBloc = EventBloc();
