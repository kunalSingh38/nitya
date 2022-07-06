// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nitya/model/user.dart';
import 'package:nitya/ui/common/notification_app_bar.dart';
import 'package:nitya/ui/profile/bloc/profile_bloc.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:nitya/utils/constants.dart';
import 'package:nitya/utils/prefs_helper.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _orgController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  void setData() async {
    _nameController.text = AppUtils.namify(AppUtils.currentUser?.name);

    _phoneController.text = AppUtils.currentUser?.phoneNo;
    _orgController.text = await PrefsHelper.getOrg() ?? "";
    _designationController.text = await PrefsHelper.getDesignation() ?? "";

    _emailController.text = AppUtils.currentUser?.email;
  }

  final ProfileBloc _bloc = ProfileBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FirebaseAnalytics().setCurrentScreen(
    //   screenName: "Profile",
    // );
    setData();
    _bloc.profileStream.listen((event) {
      AppUtils.currentUser = event;
      AppUtils.showError("Profile Updated", _key);
    });

    _bloc.errorStream.listen((event) {
      AppUtils.showError(event, _key);
    });

    _bloc.loadingStream.listen((event) {
      if (context != null) if (event) {
        AppUtils.showLoadingDialog(context);
      } else {
        Navigator.pop(context);
      }
    });
  }

  //final DateTime now = DateTime.now();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: PreferredSize(
          child: NotificationAppBar("Profile"),
          preferredSize: Size.fromHeight(56)),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(6)),
                      child: TextFormField(
                        controller: _nameController,
                        cursorColor: kPrimaryColor,
                        validator: (v) {
                          if (v.isEmpty) return "Required";
                          if (v.length < 3)
                            return "Should be 3 or more letters";

                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: "David Joe",
                          labelText: "Name",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(6)),
                      child: TextField(
                        controller: _phoneController,
                        cursorColor: kPrimaryColor,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          suffixIcon: Container(
                            margin: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: kPrimaryColor)),
                            child: Icon(
                              Icons.done,
                              color: kPrimaryColor,
                            ),
                          ),
                          isDense: true,
                          border: InputBorder.none,
                          hintText: "10 Digits",
                          labelText: "Mobile Number",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(6)),
                      child: TextFormField(
                        controller: _orgController,
                        validator: (v) {
                          if (v.isEmpty) return "Required";
                          return null;
                        },
                        enableInteractiveSelection: false,
                        cursorColor: kPrimaryColor,
                        onTap: () async {},
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: "Type your orgainization",
                          labelText: "Organization",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(6)),
                      child: TextFormField(
                        controller: _designationController,
                        enabled: true,
                        validator: (v) {
                          if (v.isEmpty) return "Required";

                          return null;
                        },
                        enableInteractiveSelection: false,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: "Type your designation",
                          labelText: "Designation",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(6)),
                      child: TextFormField(
                        controller: _emailController,
                        cursorColor: kPrimaryColor,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v.isEmpty) return "Required";
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(v)) return "Enter valid email";

                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: "someone@me.com",
                          labelText: "Email",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                color: kPrimaryColor,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    String accessToken = AppUtils.currentUser.accessToken;
                    String phoneNo = _phoneController.text;
                    String email = _emailController.text;
                    String name = _nameController.text;
                    String org = _orgController.text;
                    String des = _designationController.text;
                    _bloc.updateProfile(
                        email, phoneNo, name, accessToken, org, des);
                    PrefsHelper.saveExtras(org, des);
                  }
                },
                child: Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return date.day.toString() +
        "/" +
        date.month.toString() +
        "/" +
        date.year.toString();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
