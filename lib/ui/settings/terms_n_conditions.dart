import 'package:flutter/material.dart';
import 'package:nitya/ui/common/notification_app_bar.dart';

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: NotificationAppBar('Terms & Conditions'),
          preferredSize: Size.fromHeight(56)),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Text(
            '''Your privacy is important to us. We, at NITYA Tax Associates (‘NITYA’/’We’/’Us’) are devoted towards respecting and protecting your privacy regarding any information we may collect from you across our website, https://www.nityatax.com, and any other websites, associated mobile applications etc. we may own and/or operate.

The Privacy Policy of NITYA meets and complies with the extant laws of India. Visitors from other countries may be advised that the laws and regulations in India in relation to privacy may differ from that of other countries.

We only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent. We also let you know why we’re collecting it and how it will be used. All information provided by you will be used in accordance with the laws and regulations having the force of law in India.

We only retain collected information for as long as necessary to provide you with your requested service. What data we store, we’ll protect within commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use or modification.

We don’t share any personally identifying information publicly or with third-parties, except when required by law.

Our website may link to external sites that are not operated by us. Please be aware that we have no control over the content and practices of these sites, and cannot accept responsibility or liability for their respective privacy policies.

You are free to refuse our request for your personal information, with the understanding that we may be unable to provide you with some of your desired services.

It is hereby clarified that we may modify or update our policy from time to time. Your continued use of our website will be regarded as acceptance of our practices around privacy and personal information. If you have any questions about how we handle user data and personal information, feel free to contact us.

This policy is effective as of 1 January 2020.''',
            style: TextStyle(fontSize: 16, color: Colors.black45),
          ),
        ),
      ),
    );
  }
}
