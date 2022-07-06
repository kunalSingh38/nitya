import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         extendBody: true,
         appBar: AppBar(
            backgroundColor: Color(0xff58C6CF),
            title: Text("Contact Us", style: TextStyle(color: Colors.white)),
            centerTitle: true,
         ),
         body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Column(
                 children: [
                   _itemdata("Phone", "+91 1141091200", 'assets/images/call.png'),
                   _itemdata("Email", "info@nityatax.com", 'assets/images/email.png'),
                   _itemdata("Website", "www.nityatax.com", 'assets/images/website.png'),
                   _itemdata("Address", "B-3/58 | Third Floor | Safdarjung Enclave | New Delhi 110029", 'assets/images/location.png'),

                 ],
              ),
            ),
         ),
    );
  }

  Widget _itemdata(String title, String desc, String image){
     return Container (
       height: MediaQuery.of(context).size.height * 0.12,
       width: double.infinity,
       child: Padding(
         padding: EdgeInsets.all(4.0),
         child: Card(
           elevation: 4.0,
           color: Colors.white,
           child: Padding(
             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Align(
                     alignment: Alignment.topLeft,
                     child: Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500))
                 ),
                 SizedBox(height: 2.0),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Flexible(
                         flex: 2,
                         child: Text(desc)
                     ),
                     GestureDetector(
                       onTap: (){
                         if(title == "Phone") {
                           launch('tel:'+desc);
                         }
                         if(title == "Website"){
                            _launchWeb("https://nityatax.com/");
                         }
                         if(title ==  "Email"){
                            _launchEmail(desc);
                         }
                         if(title == "Address"){
                           _launchMapsUrl('https://goo.gl/maps/PFSbHJc2xrUDmeei7');
                         }
                         else{}
                       },
                       child: Image.asset(image),
                     )

                   ],
                 )
               ],
             ),
           ),
         ),
       ),
     );
  }

  _launchWeb(String url) async{
    if (await canLaunch(url))
      await launch(url);
    else
      // can't launch url, there is some error
      throw "Could not launch $url";
  }

  _launchEmail(String email){
    launch('mailto:$email?subject=&body=');
  }

  void _launchMapsUrl(mapsurl) async {
    final url = mapsurl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

