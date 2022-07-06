import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nitya/ui/main_page.dart';
import 'package:nitya/utils/constants.dart';
import 'package:nitya/utils/image_helper.dart';

class DisclaimerDialog extends StatelessWidget {
  final String disclaimer =
      '''Disclaimer: The rules of the Bar Council of India prohibit law firms from advertising and soliciting work through communication in the public domain. This application is meant solely for the purposes of providing information and not for the purpose of advertising. This knowledge site is not intended to be a source of advertising or solicitation and the contents of the knowledge site should not be construed as legal advice. NITYA Tax Associates do not intend to use this application for directly or indirectly soliciting or advertising an attorney-client relationship from a user of this application.
 
By proceeding further and clicking on the “I AGREE” button herein below, the user expresses acknowledgement of having read and understood the Disclaimer & Terms of Use above or please close this browser window to exit this application.''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kPrimaryColor,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 12)),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      child: SvgPicture.asset(
                        LOGO,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "DISCLAIMER",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "USER ACKNOWLEDGEMENT",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        disclaimer,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => MainPage()),
                            (route) => false);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white)
                      ),
                      child: Text(
                        "I AGREE",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
