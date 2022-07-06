// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nitya/model/user.dart';
import 'package:nitya/model/new_signup_model.dart';
import 'package:nitya/ui/disclaimer_dialog.dart';
import 'package:nitya/ui/signup/bloc/sign_up_bloc.dart';
import 'package:nitya/utils/app_utils.dart';
import 'package:nitya/utils/constants.dart';
import 'package:nitya/utils/prefs_helper.dart';
import 'package:country_code_picker/country_code_picker.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String fcmToken = "";

  final TextStyle headingStyle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w500);

  final GlobalKey<FormState> _formKey = GlobalKey();

  final SignUpBloc _bloc = SignUpBloc();

  User user;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String countryCode = "+91";
  // final TextEditingController _countryCodeController = TextEditingController();

  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    print("New Country selected: " + countryCode.toString());
    this.countryCode = countryCode.toString();
  }

  @override
  void initState() {
    super.initState();

    // FirebaseAnalytics().setCurrentScreen(
    //   screenName: "Signup",
    // );

    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        fcmToken = value.toString();
        print("fcm token " + fcmToken);
      });
    });

    _bloc.signUpStream.listen((event) {
      if (event.user != null) {
        AppUtils.currentUser = event.user;
        PrefsHelper.saveUser(event.user);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => DisclaimerDialog()));
        // showDialog(context: context, builder: (_) => DisclaimerDialog());
//        Navigator.pushReplacement(
//            context, MaterialPageRoute(builder: (_) => DisclaimerDialog()));
      } else {
//        if (event.errorCode == SIGNED_UP_NOT_VERIFIED) {
//          AppUtils.showError(event.error, _globalKey, "Verify", () {
//            Navigator.pushReplacement(
//                context,
//                MaterialPageRoute(
//                    builder: (_) => PhoneUp(_phoneController.text)));
//          });
//        } else if (event.errorCode == USER_ALREADY_EXIST) {
//          AppUtils.showError(
//              "User already exists", _globalKey, "Login", () => login());
//        } else {
        //  AppUtils.showError(event.message, _globalKey); //SignUpModel
        AppUtils.showError(event.message, _globalKey);
//        }
      }
    });

    _bloc.loadingStream.listen((event) {
      if (context != null) {
        if (event) {
          AppUtils.showLoadingDialog(context);
        } else {
          Navigator.pop(context);
        }
      }
    });

//    _bloc.errorStream.listen((event) {
//      if (event.errorCode == SIGNED_UP_NOT_VERIFIED) {
////        print("sss");
////        AppUtils.showError(event.message, _globalKey);
//        //resend otp and send user to otp page
//        Navigator.pushReplacement(context,
//            MaterialPageRoute(builder: (_) => PhoneUp(_phoneController.text)));
//      }
//      if (event.errorCode == USER_ALREADY_EXIST) {
//        AppUtils.showError(
//            "User already exists", _globalKey, "Login", () => login());
//      }
//    });
  }

//  void login() {
//    Navigator.pushReplacement(
//        context, MaterialPageRoute(builder: (_) => SignIn()));
//  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    _nameController?.dispose();
    _phoneController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 48,
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    "Sign Up",
                    style: headingStyle,
                  ),
                  subtitle: Text("Please enter the details to continue"),
                ),
                SizedBox(
                  height: 36,
                ),
                Form(
                    key: _formKey,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            cursorColor: kPrimaryColor,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(labelText: "Name"),
                            validator: (v) {
                              if (v.isEmpty) {
                                return "Field is required";
                              }
                              if (v.length < 3) {
                                return 'Name should be 3 or more letters';
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          // Row(
                          //   children: [
                          //     TextFormField(
                          //       controller: _phoneController,
                          //       cursorColor: kPrimaryColor,
                          //       keyboardType: TextInputType.phone,
                          //       decoration:
                          //           InputDecoration(labelText: "Mobile Number"),
                          //       validator: (v) {
                          //         if (v.isEmpty) {
                          //           return 'Field is required';
                          //         } else if (v.length != 10) {
                          //           return 'Value should be 10 Digits';
                          //         }
                          //         String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                          //         RegExp regExp = new RegExp(pattern);
                          //
                          //         if (!regExp.hasMatch(v)) {
                          //           return 'Please enter valid mobile number';
                          //         }
                          //
                          //         return null;
                          //       },
                          //     ),
                          //
                          //   ],

                          TextFormField(
                            controller: _phoneController,
                            cursorColor: kPrimaryColor,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "Mobile Number",
                              prefix: SizedBox(
                                width: 125,
                                height: 52,
                                child: CountryCodePicker(
                                  onChanged: _onCountryChange,
                                  initialSelection: 'IN',
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  favorite: ['+91', 'IN'],
                                  enabled: true,
                                  hideMainText: false,
                                  showFlagMain: true,
                                  showFlag: true,
                                  hideSearch: false,
                                  alignLeft: true,
                                ),
                              ),
                            ),
                            validator: (v) {
                              if (v.isEmpty) {
                                return 'Field is required';
                              } else if (v.length != 10) {
                                return 'Value should be 10 Digits';
                              }
                              String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                              RegExp regExp = new RegExp(pattern);

                              if (!regExp.hasMatch(v)) {
                                return 'Please enter valid mobile number';
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _emailController,
                            cursorColor: kPrimaryColor,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(labelText: "Email Id"),
                            validator: (v) {
                              if (v.isEmpty) {
                                return 'Field is required';
                              }
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(v);
                              if (!emailValid) {
                                return "Enter valid email";
                              }
                              return null;
                            },
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
                                //print("fcm token "+AppUtils.fcmToken.toString());
                                _bloc.signUp(
                                    name: _nameController.text.trim(),
                                    phone: _phoneController.text.trim(),
                                    countryCode: countryCode,
                                    email: _emailController.text,
                                    fcmToken: fcmToken.toString());
                              }
                            },
                            child: Text(
                              "Next",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
//                          Text(
//                            "You will receive an OTP on the mobile number you entered, for verification.",
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                fontSize: 12,
//                                color: Colors.black.withOpacity(0.50)),
//                          )
                        ],
                      ),
                    )),
//                Container(
//                  margin: EdgeInsets.only(top: 196),
//                  child: RichText(
//                    text: TextSpan(
//                        style: TextStyle(fontSize: 14, color: Colors.black45),
//                        text: "Already have an account? ",
//                        children: [
//                          TextSpan(
//                              recognizer: TapGestureRecognizer()
//                                ..onTap = () => login(),
//                              text: "Sign In",
//                              style: TextStyle(color: kPrimaryColor))
//                        ]),
//                  ),
//                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
