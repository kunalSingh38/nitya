import 'package:flutter/material.dart';
import 'package:nitya/model/bytes_model.dart';
import 'package:nitya/ui/byte/bloc/bytes_bloc.dart';
import 'package:nitya/ui/byte/byte_item.dart';
import 'package:nitya/ui/common/error_page.dart';
import 'package:nitya/ui/common/loading_page.dart';
import 'package:nitya/utils/app_utils.dart';

class BytesPage extends StatefulWidget {
  @override
  _BytesPageState createState() => _BytesPageState();
}

class _BytesPageState extends State<BytesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<ByteResponse>(
      stream: bytesBloc.bytes,
      builder: (context, AsyncSnapshot<ByteResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return ErrorPage(
              errorMsg: snapshot.data.error,
              retry: fetchBytes,
            );
          }
          return snapshot.data.bytes.isEmpty
              ? Center(child: Text("Nothing Here"))
              : ListView.separated(
                  itemBuilder: (_, index) {
                    return ByteItem(snapshot.data.bytes[index]);
                  },
                  separatorBuilder: (_, __) => Divider(),
                  itemCount: snapshot.data.bytes.length);
        } else if (snapshot.hasError) {
          return ErrorPage(
            errorMsg: snapshot.error,
            retry: fetchBytes,
          );
        } else {
          return LoadingPage("Fetching Bytes");
        }
      },
    ));
  }

  Future<void> fetchBytes() async {
    await bytesBloc.fetchBytes(AppUtils.currentUser.accessToken);
    return;
  }
}
