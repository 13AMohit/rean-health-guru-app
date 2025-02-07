import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';
import 'package:patient/core/constants/remote_config_values.dart';
import 'package:patient/core/constants/route_paths.dart';
import 'package:patient/features/misc/models/patient_api_details.dart';
import 'package:patient/features/misc/ui/login_with_otp_view.dart';
import 'package:patient/infra/networking/api_provider.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/shared_prefUtils.dart';
import 'package:patient/infra/widgets/confirmation_bottom_sheet.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final _sharedPrefUtils = SharedPrefUtils();
  String name = '';
  String? mobileNumber = '';
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );
  String profileImage = '';
  ApiProvider? apiProvider = GetIt.instance<ApiProvider>();
  String? _baseUrl = '';
  String imageResourceId = '';

  loadSharedPrefs() async {
    try {
      final Patient patient =
      Patient.fromJson(await _sharedPrefUtils.read('patientDetails'));
      //debugPrint(user.toJson().toString());
      setState(() {
        name = patient.user!.person!.firstName! +
            ' ' +
            patient.user!.person!.lastName!;

        mobileNumber = patient.user!.person!.phone;
        imageResourceId = patient.user!.person!.imageResourceId ?? '';
        profileImage = imageResourceId != ''
            ? apiProvider!.getBaseUrl()! +
            '/file-resources/' +
            imageResourceId +
            '/download'
            : '';
      });
      _baseUrl = apiProvider!.getBaseUrl();
    } catch (Excepetion) {
      // do something
      debugPrint(Excepetion.toString());
    }
  }

  @override
  void initState() {
    _initPackageInfo();
    super.initState();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _packageInfo = info;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    loadSharedPrefs();
    return Drawer(
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        semanticContainer: false,
        elevation: 0,
        child: Container(
          color: colorF6F6FF,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _createHeader(),
              _menuItems(),
              _footer(),

              /* _createDrawerItem(
                  icon: Icons.note,
                  text: 'Notes',
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, RoutePaths.notes)),
              Divider(),
              _createDrawerItem(icon: Icons.collections_bookmark, text: 'Steps'),
              _createDrawerItem(icon: Icons.face, text: 'Authors'),
              _createDrawerItem(
                  icon: Icons.account_box, text: 'Flutter Documentation'),
              _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),
              Divider(),
              _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),*/
              /* ListTile(
                title: Text('0.0.1'),
                onTap: () {},
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItems() {
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_edit_profile_button_click');
                Navigator.popAndPushNamed(context, RoutePaths.Edit_Profile);
              },
              child: Container(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_medical_profile_button_click');
                Navigator.popAndPushNamed(context, RoutePaths.My_Medical_Profile);
              },
              child: Container(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Medical Profile',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*InkWell(
                onTap: () {
                  Navigator.popAndPushNamed(context, RoutePaths.My_Vitals);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Vital',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),*/
          /*InkWell(
                onTap:(){
                  Navigator.popAndPushNamed(context, RoutePaths.My_Vitals_By_Device_Framework);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 40,),
                      Text("Health Kit", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
              ),*/
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                FirebaseAnalytics.instance.logEvent(name: 'navigation_my_medication_button_click');
                Navigator.popAndPushNamed(context, RoutePaths.My_Medications, arguments: 0);
              },
              child: Container(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Medications',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*if (Platform.isIOS) ...[*/
          Visibility(
            visible: false,
            child: Semantics(
              button: true,
              child: InkWell(
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(name: 'navigation_my_activity_button_click');
                  Navigator.popAndPushNamed(context, RoutePaths.My_Activity);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Activity',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //],
          /*InkWell(
                onTap: () {
                  Navigator.popAndPushNamed(context, RoutePaths.My_Nutrition,
                      arguments: '');
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Nutrition',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),*/
          Visibility(
            visible: RemoteConfigValues.carePlanCode.isNotEmpty,
            /*visible: getBaseUrl()!.contains('aha-api-uat') ||
                getBaseUrl()!.contains('reancare-api-dev') ||
                getAppName() == 'Heart & Stroke Helper™ ',*/
            child: Semantics(
              button: true,
              child: InkWell(
                onTap: () {
                  if (carePlanEnrollmentForPatientGlobe == null) {
                    Navigator.popAndPushNamed(
                        context, RoutePaths.Select_Care_Plan);
                    FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_select_health_journey_button_click');
                  } else {
                    FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_view_health_journey_status_button_click');
                    Navigator.popAndPushNamed(context, RoutePaths.My_Care_Plan);
                  }
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Health Journey',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: true,
            child: InkWell(
              onTap: () {
                FirebaseAnalytics.instance.logEvent(name: 'navigation_achievement_button_click');
                Navigator.popAndPushNamed(
                    context, RoutePaths.ACHIEVEMENT);
              },
              child: Container(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Hero(
                      tag: 'header',
                      child: Text(
                        'Achievements',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*InkWell(
                onTap: (){
                  //Navigator.popAndPushNamed(context, RoutePaths.Set_Goals_Care_Plan);
                  Navigator.popAndPushNamed(context, RoutePaths.Self_Reflection_For_Goals_Care_Plan);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 40,),
                      Text("Self Reflection", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
              ),*/
          /*InkWell(
                onTap: (){
                  Navigator.popAndPushNamed(context, RoutePaths.Quiz_Care_Plan);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 40,),
                      Text("Quiz", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.popAndPushNamed(context, RoutePaths.Assessment_Start_Care_Plan);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 40,),
                      Text("Assessment", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.popAndPushNamed(context, RoutePaths.My_Care_Plan);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 40,),
                      Text("Care Plan", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
              ),*/

              /* InkWell(
                onTap: (){
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 40,),
                      Text("Helpdesk", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
              ),*/
          Visibility(
            visible: getAppName() != 'Heart & Stroke Helper™ ',
            child: Semantics(
              button: true,
              child: InkWell(
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_about_button_click');
                  Navigator.popAndPushNamed(context, RoutePaths.ABOUT_REAN_CARE);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        getAppType() == 'AHA' ? 'About Us' : 'About REAN',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_contact_us_button_click');
                Navigator.popAndPushNamed(context, RoutePaths.CONTACT_US);
              },
              child: Container(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Contact Us',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: getAppType() == 'AHA',
            child: Semantics(
              button: true,
              child: InkWell(
                onTap: () {
                  FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_support_network_button_click');
                  Navigator.popAndPushNamed(context, RoutePaths.SUPPORT_NETWORK);
                },
                child: Container(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'Support Network',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
          ),
        ],
      ),
    ));
  }

  Widget _footer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Semantics(
          button: true,
          child: InkWell(
            onTap: () {
              FirebaseAnalytics.instance.logEvent(name: 'navigation_menu_logout_button_click');
              _logoutConfirmation();
            },
            child: Container(
              color: primaryColor,
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
        Semantics(
          child: Container(
            height: 56,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 40,
                ),
                Text(
                  'Version ' +
                      (_baseUrl!.contains('dev')
                          ? 'Dev_'
                          : _baseUrl!.contains('uat')
                              ? 'Alpha_'
                              : '') +
                      _packageInfo.version,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                      color: primaryColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _logoutConfirmation() {
    /*showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            'Alert!',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
                color: Colors.black),
          ),
          contentPadding: EdgeInsets.all(4.0),
          subtitle: Text(
            '\nAre you sure you want to logout?',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontSize: 16.0,
                color: Colors.black),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              carePlanEnrollmentForPatientGlobe = null;
              _sharedPrefUtils.save('CarePlan', null);
              _sharedPrefUtils.saveBoolean('login', null);
              _sharedPrefUtils.clearAll();
              chatList.clear();
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return LoginWithOTPView();
              }), (Route<dynamic> route) => false);
            },
          ),
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
    );*/
    //Navigator.pop(context);
    ConfirmationBottomSheet(
        context: context,
        height: 180,
        onPositiveButtonClickListner: () {
          dailyCheckInDate = '';
          debugPrint('Positive Button Click');
          carePlanEnrollmentForPatientGlobe = null;
          _sharedPrefUtils.save('CarePlan', null);
          _sharedPrefUtils.saveBoolean('login', null);
          _sharedPrefUtils.clearAll();
          chatList.clear();
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return LoginWithOTPView();
          }), (Route<dynamic> route) => false);
        },
        onNegativeButtonClickListner: () {
          //debugPrint('Negative Button Click');
        },
        question: 'Are you sure you want to logout?',
        tittle: 'Alert!');
  }

  Widget _createHeader() {
    return /*DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('res/images/drawer_header_background.png'))),
        child:*/
      Container(
        padding: const EdgeInsets.all(16.0),

        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 88,
              width: 88,
              child: Stack(
                children: <Widget>[
                  /*CircleAvatar(
                      radius: 88,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                          radius: 88,
                          backgroundImage:  profileImage == "" ? AssetImage('res/images/profile_placeholder.png') : new NetworkImage(profileImage)),
                    ),*/
                  Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        image: (profileImage == ''
                            ? AssetImage('res/images/profile_placeholder.png')
                            : CachedNetworkImageProvider(profileImage))
                        as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      border: Border.all(
                        color: primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                  /*Align(
                      alignment: Alignment.topRight,
                      child: InkWell( onTap: (){ }, child: SizedBox( height: 32, width: 32, child: new Image.asset('res/images/ic_camera.png'))),
                    )*/
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Semantics(
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryColor),
                semanticsLabel: name,
              ),
            ),
            SizedBox(
              height: 4,
            ),

            Text(
              mobileNumber!,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: textBlack),
              semanticsLabel: "Phone: " +
                  mobileNumber!
                      .replaceAllMapped(RegExp(r".{1}"),
                          (match) => "${match.group(0)} "),
            ),
          ],
        ),

        // )
      );
  }
}