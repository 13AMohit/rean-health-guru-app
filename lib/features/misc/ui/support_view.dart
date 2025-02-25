
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/features/misc/models/user_data.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:patient/infra/widgets/bezier_container.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportView extends StatefulWidget {
  @override
  _SupportViewState createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  //var model = PatientCarePlanViewModel();
  String msg = 'We are here to help you so please get in touch.';
  String msgAHA = 'Please email us for technical help.';
  String subtitle =
      'For medical help, please contact your health care professional.';
  String phone = '+12025397323';
  String email = 'support@reanfoundation.org';
  final SharedPrefUtils _sharedPrefUtils = SharedPrefUtils();
  String name = ' ';
  String? userPhone = ' ';

  loadSharedPrefs() async {
    try {
      final UserData user =
          UserData.fromJson(await _sharedPrefUtils.read('user'));
      final Patient patient =
          Patient.fromJson(await _sharedPrefUtils.read('patientDetails'));
      auth = user.data!.accessToken;
      patientUserId = user.data!.user!.id;
      //debugPrint(user.toJson().toString());

      setState(() {
        name = patient.user!.person!.firstName! +
            ' ' +
            patient.user!.person!.lastName!;
        userPhone = patient.user!.person!.phone;
      });
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion.toString());
    }
  }

  @override
  void initState() {
    if(getAppType() == 'AHA'){
      email = 'helperapp@heart.org';
    }
    //completeMessageTaskOfAHACarePlan(widget.assortedViewConfigs.task);
    loadSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BaseWidget<PatientCarePlanViewModel?>(
      //model: model,
      builder: (context, model, child) => Container(
          child: Scaffold(
              backgroundColor: colorF6F6FF,
              body: Container(
                height: height,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: -height * .15,
                        right: -MediaQuery.of(context).size.width * .4,
                        child: BezierContainer()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 7,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if(getAppType() == 'AHA')
                                    SizedBox(height: 80,),
                                  Semantics(
                                    label: 'Support',
                                    image: true,
                                    child: ExcludeSemantics(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: getAppType() == 'AHA'
                                            ? Image.asset(
                                                'res/images/support_us_aha.png',
                                                semanticLabel:
                                                    'Contact us image',
                                              )
                                            : Lottie.asset(
                                                'res/lottiefiles/support_us.json',
                                              ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32.0),
                                    child: Text(
                                        getAppType() == 'AHA' ? msgAHA : msg,
                                        textAlign: TextAlign.center,
                                        semanticsLabel: getAppType() == 'AHA'
                                            ? msgAHA
                                            : msg,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            color: primaryColor)),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32.0),
                                    child: Text(subtitle,
                                        semanticsLabel: subtitle,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: primaryColor)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if(getAppType() != 'AHA')...[
                                      Semantics(
                                        label: 'Call Us',
                                        button: true,
                                        child: InkWell(
                                          onTap: () async {
                                            FirebaseAnalytics.instance.logEvent(name: 'contact_us_call_us_button_click');
                                            final String url = 'tel://' + phone;
                                            if (await canLaunchUrl(Uri.parse(url))) {
                                              await launchUrl(Uri.parse(url));
                                            } else {
                                              showToast('Unable to dial number',
                                                  context);
                                              debugPrint(
                                                  'Could not launch $url');
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          child: ExcludeSemantics(
                                            child: Card(
                                              semanticContainer: true,
                                              elevation: 8.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              color: colorF6F6FF,
                                              shadowColor: colorF6F6FF,
                                              child: Container(
                                                height: 160,
                                                width: 120,
                                                child: Column(
                                                  children: [
                                                    getAppType() == 'AHA'
                                                        ? Image.asset(
                                                            'res/images/ic_call_aha.png',
                                                            width: 120)
                                                        : Lottie.asset(
                                                            'res/lottiefiles/call.json',
                                                            height: 120,
                                                          ),
                                                    Text('Call us',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                            color:
                                                                primaryColor)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                    Semantics(
                                      label: 'Email us',
                                      button: true,
                                      child: InkWell(
                                        onTap: () async {
                                          FirebaseAnalytics.instance.logEvent(name: 'contact_us_email_us_button_click');
                                          /* final Uri _emailLaunchUri = Uri(
                                            scheme: 'mailto',
                                            path: email,
                                            queryParameters: {
                                              'subject': 'REAN%2BCare%2Bapp%2Bquery',
                                              'body': 'Hey Team, \n'+name+' wants to get in touch\nContact Number: '+userPhone,
                                            }
                                        );*/

                                          String appName =
                                              'REAN%20HealthGuru';
                                          if (getAppType() == 'AHA') {
                                            appName = Uri.parse(getAppName().replaceAll('™ ', '')).toString();
                                          }

                                          final link = 'mailto:' +
                                              email +
                                              '?subject=Regarding%20' +
                                              appName +
                                              '%20App&body=Hey Team,%20\n\n' +
                                              name +
                                              '%20wants%20to%20get%20in%20touch%20with%20you.\n\nContact%20Number:%20' +
                                              userPhone! +
                                              '\n\n';
                                            if (await canLaunchUrl(Uri.parse(
                                                link.toString()))) {
                                              await launchUrl(Uri.parse(link.toString()));
                                            } else {
                                            final Uri _emailLaunchUri = Uri(
                                                scheme: 'mailto',
                                                path: email,
                                                queryParameters: {
                                                  'subject':
                                                      appName.replaceAll(
                                                              '%20', ' ') +
                                                          ' app query',
                                                  'body': ''
                                                          '' +
                                                      name +
                                                      ' wants to get in touch with you. ---- '
                                                          'Contact Number:' +
                                                      userPhone! +
                                                      ''
                                                          '',
                                                });
                                            await launchUrl(Uri.parse(_emailLaunchUri
                                                .toString()
                                                .replaceAll('+', '%20')));

                                            debugPrint(
                                                'Could not launch ${link.toString()}');
                                            throw 'Could not launch ${link.toString()}';
                                          }
                                        },
                                        child: ExcludeSemantics(
                                          child: Card(
                                            semanticContainer: true,
                                            elevation: 8.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            color: colorF6F6FF,
                                            shadowColor: colorF6F6FF,
                                            child: Container(
                                              height: 160,
                                              width: 120,
                                              child: Column(
                                                children: [
                                                  getAppType() == 'AHA'
                                                      ? Image.asset(
                                                          'res/images/ic_mail_aha.png',
                                                          width: 120)
                                                      : Lottie.asset(
                                                          'res/lottiefiles/mail.json',
                                                          height: 120,
                                                        ),
                                                  Text('Email us',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                          color:
                                                              primaryColor)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                    Positioned(top: 40, left: 0, child: _backButton()),
                  ],
                ),
              ))),
    );
  }

  Widget _backButton() {
    return Semantics(
      label: 'Back',
      button: true,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                //padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              /*Text('Back',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))*/
            ],
          ),
        ),
      ),
    );
  }

/*completeMessageTaskOfAHACarePlan(Task task) async {
    try {
      StartTaskOfAHACarePlanResponse _startTaskOfAHACarePlanResponse = await model.completeMessageTaskOfAHACarePlan(startCarePlanResponseGlob.data.carePlan.id.toString(), task.details.id);

      if (_startTaskOfAHACarePlanResponse.status == 'success') {
        assrotedUICount = 0;
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
              return HomeView( 1 );
            }), (Route<dynamic> route) => false);
        debugPrint("AHA Care Plan ==> ${_startTaskOfAHACarePlanResponse.toJson()}");
      } else {
        showToast(_startTaskOfAHACarePlanResponse.message);
      }
    } catch (CustomException) {
      model.setBusy(false);
      showToast(CustomException.toString(), context);
      debugPrint(CustomException.toString());
    }
  }

*/
}
