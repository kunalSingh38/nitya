// import 'dart:io';
//
// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';
//
// class PdfViewer extends StatefulWidget {
//   final String title;
//   final String url;
//
//   PdfViewer(this.title, this.url);
//
//   @override
//   _PdfViewerState createState() => _PdfViewerState();
// }
//
// class _PdfViewerState extends State<PdfViewer> {
//   bool isLoading;
//   String error;
//
//   @override
//   void initState() {
//     super.initState();
//     init();
//   }
//
//   PDFDocument pdf;
//
//   init() async {
//     FlutterDownloader.initialize();
//     setState(() {
//       isLoading = true;
//     });
//     print(widget.url);
//     pdf = await PDFDocument.fromURL(widget.url).catchError((e) {
//       setState(() {
//         isLoading = false;
//         error = "Something went wrong";
//       });
//     });
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         actions: [
//           IconButton(
//               icon: Icon(Icons.file_download),
//               onPressed: !isLoading && error == null
//                   ? () async {
//                       Directory downloadsDirectory =
//                           await DownloadsPathProvider.downloadsDirectory;
//
//                       String appDocPath = downloadsDirectory.path;
//                       print(appDocPath);
//                       FlutterDownloader.enqueue(
//                           url: widget.url,
//                           savedDir: appDocPath,
//                           showNotification: true,
//                           // show download progress in status bar (for Android)
//                           openFileFromNotification:
//                               true, // click on notification to open downloaded file (for Android)
//                           fileName: widget.title);
//                     }
//                   : null)
//         ],
//         iconTheme: IconThemeData(color: Colors.white),
//         title: Text(
//           "${widget.title}",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Builder(builder: (context) {
//         if (!isLoading && error != null) {
//           return Center(
//             child: Text(error),
//           );
//         }
//         return isLoading
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : PDFViewer(
//                 document: pdf,
//               );
//       }),
//     );
//   }
// }
