
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:patient/features/common/careplan/models/assorted_view_configs.dart';
import 'package:patient/features/common/careplan/models/get_user_task_details.dart';
import 'package:patient/features/common/careplan/view_models/patients_careplan.dart';
import 'package:patient/features/misc/models/base_response.dart';
import 'package:patient/features/misc/ui/base_widget.dart';
import 'package:patient/features/misc/ui/home_view.dart';
import 'package:patient/infra/networking/custom_exception.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:patient/infra/utils/string_utility.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

//ignore: must_be_immutable
class LearnMoreCarePlanView extends StatefulWidget {
  AssortedViewConfigs? assortedViewConfigs;

  LearnMoreCarePlanView(this.assortedViewConfigs);

  @override
  _LearnMoreCarePlanViewState createState() => _LearnMoreCarePlanViewState();
}

class _LearnMoreCarePlanViewState extends State<LearnMoreCarePlanView> {
  var model = PatientCarePlanViewModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//https://www.youtube.com/watch?v=s1pG7k_1nSw
  String videourl = 'https://www.youtube.com/watch?v=d8PzoTr95ik';
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);
  String textMsg1 =
      'Welcome to the Connected Heart Health CarePlan. For the next 12 weeks you will be given daily activities designed to help you manage your condition.\n\nThese activities will include education, assessments, challenges, and communication. We will begin with some foundational information and developing your self CarePlan.';
  String textMsg2 =
      "Heart Failure is a chronic, progressive condition in which the heart muscle is unable to pump enough blood through the heart to meet the body's needs for blood and oxygen.\n\nHeart failure usually results in an enlarged heart.";

  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'd8PzoTr95ik',
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  String unformatedDOB = '';
  var dateFormat = DateFormat('dd MMM, yyyy');

  @override
  void initState() {
    //completeMessageTaskOfAHACarePlan(widget.assortedViewConfigs.task);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PatientCarePlanViewModel?>(
      model: model,
      builder: (context, model, child) => Container(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: primaryColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: primaryColor,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
            title: Text(
              widget.assortedViewConfigs!.header == ''
                  ? 'Learn More!'
                  : widget.assortedViewConfigs!.header!,
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            actions: <Widget>[
              /*IconButton(
                icon: Icon(
                  Icons.person_pin,
                  color: Colors.black,
                  size: 32.0,
                ),
                onPressed: () {
                  debugPrint("Clicked on profile icon");
                },
              )*/
            ],
          ),
          body: Stack(
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    color: primaryColor,
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: primaryColor,
                    height: 0,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12))),
                      child: body(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        headerText(),
        SizedBox(
          height: 16,
        ),
        Expanded(
          child: widget.assortedViewConfigs!.toShow == '1'
              ? iMageView()
              : widget.assortedViewConfigs!.toShow == '2'
                  ? audioView()
                  : videoView(),
        ),
        footer(),
      ],
    );
  }

  Widget headerText() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: colorF6F6FF,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
      ),
      child: Center(
        child: Text(
          widget.assortedViewConfigs!.task!.action!.title.toString(),
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget footer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /*assrotedUICount != 3 ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: (){

                  AssortedViewConfigs newAssortedViewConfigs =  new AssortedViewConfigs();
                  if(assrotedUICount == 1) {
                      newAssortedViewConfigs.toShow = "1";
                      newAssortedViewConfigs.testToshow = "1";
                      newAssortedViewConfigs.isNextButtonVisible = true;

                      Navigator.pushNamed(
                          context, RoutePaths.Learn_More_Care_Plan,
                          arguments: newAssortedViewConfigs);
                      assrotedUICount = 2;
                  } else if(assrotedUICount == 2) {
                    newAssortedViewConfigs.toShow = "1";
                    newAssortedViewConfigs.testToshow = "2";
                    newAssortedViewConfigs.isNextButtonVisible = false;

                    Navigator.pushNamed(
                        context, RoutePaths.Learn_More_Care_Plan,
                        arguments: newAssortedViewConfigs);
                    assrotedUICount = 3;
                  }else{
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                          return HomeView( 0 );
                        }), (Route<dynamic> route) => false);
                  }

                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 40,
                    width: 160,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: primaryColor, width: 1),
                      color: primaryColor,),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios, color: primaryColor, size: 16,),
                        Text(
                          assrotedUICount != 3 ? 'Next' : 'Done',
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16,),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
              :
          Container(),
          const SizedBox(height: 40,),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (model.busy)
                CircularProgressIndicator()
              else
                InkWell(
                  onTap: () {
                    /*assrotedUICount = 0;
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                          return HomeView( 0 );
                        }), (Route<dynamic> route) => false);*/
                    if (widget.assortedViewConfigs!.task!.finished) {
                      Navigator.pop(context);
                    } else {
                      completeMessageTaskOfAHACarePlan(
                          widget.assortedViewConfigs!.task);
                    }
                  },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                            height: 40,
                            width: 160,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(color: primaryColor, width: 1),
                          color: primaryColor,
                        ),
                            child:
                            /* assrotedUICount != 3 ?  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios, color: primaryColor, size: 16,),
                        Text(
                          'Skip All',
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16,),
                      ],
                    )
                    :*/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Done',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 14),
                                ),
                              ],
                            )),
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }

  Widget audioView() {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _launchURL(widget.assortedViewConfigs!.task!.action!.url
                        .toString());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: 40,
                        width: 160,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(color: primaryColor, width: 1),
                          color: primaryColor,
                        ),
                        child:
                        /* assrotedUICount != 3 ?  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_ios, color: primaryColor, size: 16,),
                          Text(
                            'Skip All',
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16,),
                        ],
                      )
                      :*/
                            Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Play Audio',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 14),
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.assortedViewConfigs!.task!.action!.description ?? '',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget iMageView() {
    debugPrint(
        'Image Visible ==> ${widget.assortedViewConfigs!.task!.action!.type == 'Infographic'}');
    debugPrint(
        'Image URL ==> ${widget.assortedViewConfigs!.task!.action!.url}');
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.assortedViewConfigs!.task!.action!.url != null) ...[
              Visibility(
                visible: widget.assortedViewConfigs!.task!.action!.type ==
                    'Infographic',
                child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.network(
                      widget.assortedViewConfigs!.task!.action!.url!,
                      fit: BoxFit.cover,
                    )),
              ),
            ],
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.assortedViewConfigs!.task!.action!.transcription!,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  videoView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(
            controller: _controller,
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      showToast('Could not launch $url', context);
      //throw 'Could not launch $url';
    }
  }

  completeMessageTaskOfAHACarePlan(UserTask? task) async {
    try {
      final BaseResponse response =
          await model.finishUserTask(task!.action!.userTaskId.toString());

      if (response.status == 'success') {
        showSuccessToast('Task completed successfully!', context);
        assrotedUICount = 0;
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomeView(1);
        }), (Route<dynamic> route) => false);
        debugPrint('AHA Care Plan ==> ${response.toJson()}');
      } else {
        showToast(response.message!, context);
      }
    } on FetchDataException catch (e) {
      model.setBusy(false);
      showToast(e.toString(), context);
      debugPrint('Error ==> ' + e.toString());
    }
  }
}
