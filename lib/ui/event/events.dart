import 'package:flutter/material.dart';
import 'package:nitya/model/event.dart';
import 'package:nitya/ui/common/error_page.dart';
import 'package:nitya/ui/common/loading_page.dart';
import 'package:nitya/ui/event/bloc/event_bloc.dart';
import 'package:nitya/ui/event/event_item.dart';
import 'package:nitya/utils/app_utils.dart';

class Events extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder<EventResponse>(
          stream: eventBloc.events,
          builder: (context, AsyncSnapshot<EventResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return ErrorPage(
                  errorMsg: snapshot.data.error,
                  retry: fetchEvents,
                );
              }
              return buildEvents(snapshot.data.events);
            } else if (snapshot.hasError) {
              return ErrorPage(
                errorMsg: snapshot.error,
                retry: fetchEvents,
              );
            } else {
              return LoadingPage("Fetching Events");
            }
          },
        ),
      ),
    );
  }

  Future<void> fetchEvents() async {
    await eventBloc.fetchEvents(AppUtils.currentUser.accessToken);
    return;
  }

  Widget buildEvents(List<EventModel> events) {
    return RefreshIndicator(
      onRefresh: fetchEvents,
      child: ListView.separated(
        itemBuilder: (_, index) {
          return EventItem(events[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            height: 1,
            color: Colors.grey.shade300,
          );
        },
        itemCount: events.length,
      ),
    );
  }
}
