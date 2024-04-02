import 'dart:developer';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/commonWidgets/myBtnSelector.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:provider/provider.dart';

import '../../commonWidgets/backIcon.dart';
import '../../commonWidgets/myConfirmationDialog.dart';
import '../../commonWidgets/myLoadingBtn.dart';
import '../../configuration/images.dart';
import '../../configuration/theme.dart';
import '../../models/coursesModel.dart';
import '../../models/opportunityModel.dart';
import '../../providers/opportunityProvider.dart';
import 'applyOpportunityPage.dart';

class OpportunityDetailsPage extends StatefulWidget {
  const OpportunityDetailsPage({Key? key , this.opportunity, this.applyOpportunityID}) : super(key: key);
  final Opportunity? opportunity ;
  final String? applyOpportunityID ;
  @override
  State<OpportunityDetailsPage> createState() => _OpportunityDetailsPageState();
}

class _OpportunityDetailsPageState extends State<OpportunityDetailsPage> {
  bool showAllLines = false;
  bool showAllLinesRequirements = false;
  bool showAllLinesCourses = false;
  double myRate = 0.0 ;
  List<Courses> courses = [] ;
  bool? isApplied  ;
  String? opportunityStatus  ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    courses.addAll([
      Courses(id: "1" , title: "Microsoft Power BI Data Analyst Professional" , source: "coursera" , image: "https://cdn.icon-icons.com/icons2/2699/PNG/512/coursera_logo_icon_170320.png"  ),
      Courses(id: "2" , title: "Data Analysis with Pandas and Python" , source: "Udemy" , image: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Udemy_logo.svg/2560px-Udemy_logo.svg.png"  ),
      Courses(id: "3" , title: "Professional Certificate in Data analyst" , source: "edX" , image: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/EdX_newer_logo.svg/2560px-EdX_newer_logo.svg.png"  ),
    ]);
    Provider.of<OpportunityProvider>(context, listen: false).getRate(opportunity_id: widget.opportunity!.id, callBack: (double? rate){
      if(rate != null){
        myRate = rate ;
        setState(() {});
      }
    });
    Provider.of<OpportunityProvider>(context, listen: false).isApplied(opportunity_id: widget.opportunity!.id, callBack: (bool? isAppliedN){
      if(isAppliedN != null){
        isApplied = isAppliedN ;
        setState(() {});
        if(isApplied != null && isApplied == true){
          Provider.of<OpportunityProvider>(context, listen: false).getStatus(opportunity_id: widget.opportunity!.id, callBack: (String? status){
            if(status != null){
              opportunityStatus = status ;
              setState(() {});
            }
          });
        }
      }
    });
  }

  Future<void> getShareLink(BuildContext context) async {
    EasyLoading.show();

    String link = "https://jadeer.page.link/opportunity=${widget.opportunity?.id}";
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(link),
      uriPrefix: "https://jadeer.page.link",
      androidParameters: const AndroidParameters(packageName: "com.jadeer.app"),
      iosParameters: const IOSParameters(bundleId: "com.jadeer.app"),
    );
    final dynamicLink =
    await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams ,  shortLinkType: ShortDynamicLinkType.short,);

    // final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(
    //   dynamicLinkParams,
    // );
    ///
    // String shareLink = Uri.decodeFull(Uri.decodeComponent(dynamicLink.toString()),);
    EasyLoading.dismiss();

    await Share.share("${dynamicLink.shortUrl}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:  floatingActionButton(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: size_H(250),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Image.asset(ImagePath.mentorsBackgroundDetials ,height:  size_H(250) , scale: 3 , fit: BoxFit.fill , width: MediaQuery.of(context).size.width),

                      Positioned.fill(
                        top: size_H(20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: BackIcon(
                            padding: EdgeInsets.only(top: 8 , right: 8 , left: 8 ),
                            backWidget: Image.asset(ImagePath.backBtn , color: Colors.white , scale: 3),
                          ),
                        ),
                      ),

                      Positioned.fill(
                        top: size_H(20),
                        left: size_W(40),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Container(
                                color: Colors.black,
                                child: Image.network(widget.opportunity!.company_image , width: size_H(90) , height: size_H(90) ,
                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace,){
                                    return Image.network("https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg" ,
                                      width: size_H(90) , height: size_H(90),
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              )),
                        ),
                      ),

                      Positioned.fill(
                        top: size_H(20),
                        right: size_W(40),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                             if(isApplied != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if(isApplied == false)
                                  MyLoadingBtn(
                                    height: size_H(20),
                                    width: size_W(70),
                                    textStyle: ourTextStyle(fontSize: 10 , color: Theme_Information.Color_1),
                                    borderRadius: 25,
                                    text: "Apply",
                                    callBack: (Function startLoading,
                                        Function stopLoading,
                                        ButtonState btnState) {
                                      // EasyLoading.showInfo("Apply");
                                      // ApplyOpportunityPage
                                      Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => ApplyOpportunityPage(
                                        opportunity: widget.opportunity,
                                      ))).then((value) async {
                                        if(value!= null){
                                          EasyLoading.show();
                                         await Provider.of<OpportunityProvider>(context, listen: false).getRate(opportunity_id: widget.opportunity!.id, callBack: (double? rate){
                                            if(rate != null){
                                              myRate = rate ;
                                              setState(() {});
                                            }
                                          });
                                          await Provider.of<OpportunityProvider>(context, listen: false).isApplied(opportunity_id: widget.opportunity!.id, callBack: (bool? isAppliedN) {
                                            if (isAppliedN != null) {
                                              isApplied = isAppliedN;
                                              setState(() {});
                                              if (isApplied != null &&
                                                  isApplied == true) {
                                                Provider.of<
                                                    OpportunityProvider>(
                                                    context, listen: false)
                                                    .getStatus(
                                                    opportunity_id: widget
                                                        .opportunity!.id,
                                                    callBack: (String? status) {
                                                      if (status != null) {
                                                        opportunityStatus =
                                                            status;
                                                        setState(() {});
                                                      }
                                                    });
                                              }
                                            }
                                          });
                                          EasyLoading.dismiss();
                                        }
                                      });
                                    },
                                  ),
                                  SizedBox(width: size_W(5),),
                                  InkWell(
                                      onTap: () async {
                                        // EasyLoading.showInfo("Share");
                                        // Share.share('check out my website https://example.com');

                                       await getShareLink(context);

                                      },child: Image.asset("${ImagePath.share}" ,scale: 3,))
                                ],
                              ),
                              SizedBox(height: size_H(5),),
                              if(isApplied != null && isApplied == false)
                              Text("* Not Applied" , style: ourTextStyle(fontSize: 10),),
                              if(isApplied != null && isApplied == true)
                                Text("* Applied" , style: ourTextStyle(fontSize: 10 , color: Theme_Information.Color_12),),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: size_H(10),),
          Padding(
            padding: EdgeInsets.only(top: size_H(5) , bottom: size_H(5), right: size_W(40) , left: size_W(40)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.opportunity!.title}" , style: ourTextStyle(fontSize: 22 ,fontWeight: FontWeight.w600 , color: Theme_Information.Primary_Color)),
                Text("${widget.opportunity!.company}" , style: ourTextStyle(fontSize: 12, color: Theme_Information.Primary_Color)),
              ],
            ),
          ),


          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  
                  SizedBox(height: size_H(10),),
                  Padding(
                    padding: EdgeInsets.only(top: size_H(5) , bottom: size_H(5), right: size_W(40) , left: size_W(40)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildRow(title: widget.opportunity!.availability , image: ImagePath.pursuit),
                        buildRow(title: widget.opportunity!.location , image: ImagePath.pin),
                        buildRow(title: widget.opportunity!.opportunity_type , image: ImagePath.employee),
                        buildRow(title: widget.opportunity!.deadline , image: ImagePath.time),
                  
                  
                      ],
                    ),
                  ),
                  
                  
                  SizedBox(height: size_H(10),),
                  Padding(
                    padding: EdgeInsets.only(top: size_H(5) , bottom: size_H(5), right: size_W(40) , left: size_W(40)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("About the position" , style: ourTextStyle(fontSize: 14, color: Theme_Information.Primary_Color , fontWeight: FontWeight.w600)),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${widget.opportunity!.description}" , maxLines: showAllLines ? 70 : 2 , overflow: TextOverflow.ellipsis   ,
                              style: ourTextStyle(fontSize: 11, color: Theme_Information.Primary_Color)),
                        ),
                  
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showAllLines = !showAllLines;
                                });
                              },
                              child: Text(
                                showAllLines ? "Show less" : "Show more",
                                style: ourTextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                    color: Theme_Information.Primary_Color
                                ),
                              ),
                            ),
                          ],
                        ),
                  
                        SizedBox(height: size_H(20),),

                      ],
                    ),
                  ),
                  
                  
                SizedBox(height: size_H(10),),

                  Padding(
                    padding: EdgeInsets.only(top: size_H(5) , bottom: size_H(5), right: size_W(40) , left: size_W(40)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Fit assessment" , style: ourTextStyle(fontSize: 14, color: Theme_Information.Primary_Color , fontWeight: FontWeight.w600)),
                            Text("94% Match" , style: ourTextStyle(fontSize: 11, color: Theme_Information.Color_12 , fontWeight: FontWeight.w600)),
                          ],
                        ),
                        SizedBox(height: size_H(5),),
                        Column(
                          children: List.generate((showAllLinesRequirements || widget.opportunity!.requirements.length < 2)
                                  ? widget.opportunity!.requirements.length
                                      : 2, (index) {
                            final item = widget.opportunity!.requirements[index] ;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      '•',
                                      style: ourTextStyle(fontSize: 11 , color: Theme_Information.Primary_Color),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      item,
                                      style: ourTextStyle(fontSize: 11 , color: Theme_Information.Primary_Color),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text("${widget.opportunity!.requirements}" , maxLines: showAllLinesRequirements ? 70 : 2 , overflow: TextOverflow.ellipsis   ,style: ourTextStyle(fontSize: 12, color: Theme_Information.Primary_Color)),
                        // ),
                  
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showAllLinesRequirements = !showAllLinesRequirements;
                                });
                              },
                              child: Text(
                                showAllLinesRequirements ? "Show less" : "Show more",
                                style: ourTextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                    color: Theme_Information.Primary_Color
                                ),
                              ),
                            ),
                          ],
                        ),
                  
                        SizedBox(height: size_H(20),),



                      ],
                    ),
                  ),

                  SizedBox(height: size_H(10),),

                  Padding(
                    padding: EdgeInsets.only(top: size_H(5) , bottom: size_H(5), right: size_W(40) , left: size_W(40)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Recommended courses" , style: ourTextStyle(fontSize: 14, color: Theme_Information.Primary_Color , fontWeight: FontWeight.w600)),
                        SizedBox(height: size_H(5),),
                        Column(
                          children: List.generate((showAllLinesCourses || courses.length < 2)
                                  ? courses.length
                                      : 2, (index) {
                            final item = courses[index] ;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0 ),
                                        child: Image.network(
                                          '${item.image}',
                                          width: size_H(80),
                                          height: size_H(60),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: ourTextStyle(fontSize: 11 , color: Theme_Information.Primary_Color , fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                item.source,
                                                style: ourTextStyle(fontSize: 11 , color: Theme_Information.Color_7 , fontWeight: FontWeight.w700),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Image.asset("${ImagePath.show_details}" , scale: 3,),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text("${widget.opportunity!.requirements}" , maxLines: showAllLinesRequirements ? 70 : 2 , overflow: TextOverflow.ellipsis   ,style: ourTextStyle(fontSize: 12, color: Theme_Information.Primary_Color)),
                        // ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showAllLinesCourses = !showAllLinesCourses;
                                });
                              },
                              child: Text(
                                showAllLinesCourses ? "Show less" : "Show more",
                                style: ourTextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                    color: Theme_Information.Primary_Color
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: size_H(20),),
                        ///
                        // Text("Contact the mentor" , style: ourTextStyle(fontSize: 14, color: Theme_Information.Primary_Color , fontWeight: FontWeight.w600)),
                        ///
                        // SizedBox(height: size_H(10),),
                        ///
                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(40.0),
                        //     border: Border.all(
                        //       color: Theme_Information.Color_7!,
                        //       width: 1.0,
                        //     ),
                        //   ),
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(12.0),
                        //     child: Column(
                        //       children: List.generate(widget.opportunity!.socialMedia.entries.toList().length, (index) {
                        //         final item = widget.opportunity!.socialMedia.entries.toList()[index];
                        //         return Padding(
                        //           padding: const EdgeInsets.only(top: 3 , bottom: 3),
                        //           child: item.value.isEmpty ? SizedBox() : Row(
                        //             children: [
                        //               Container(width: size_W(35), child: getSocialImage(item.key)),
                        //               Container(child: Text("${item.value}" , style: ourTextStyle(fontSize: 11),)),
                        //             ],
                        //           ),
                        //         );
                        //       },)
                        //     ),
                        //   ),
                        // )

                      ],
                    ),
                  ),

                  SizedBox(height: size_H(10),),

                  Padding(
                    padding: EdgeInsets.only(top: size_H(5) , bottom: size_H(5), right: size_W(40) , left: size_W(40)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(child: Text("Your opinion matters to us!" , style: ourTextStyle(fontSize: 14, color: Theme_Information.Primary_Color , fontWeight: FontWeight.w600))),
                        SizedBox(height: size_H(15),),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(
                              color: Theme_Information.Color_7!,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top:12.0 , bottom: 12 , right: 12 , left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("How was your opportunity?" , style: ourTextStyle(fontSize: 12, color: Theme_Information.Primary_Color , fontWeight: FontWeight.w400)),
                                SizedBox(height: size_H(10),),
                                RatingBar(
                                  initialRating: myRate,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  ignoreGestures: myRate != 0,
                                  itemCount: 5,
                                  itemSize: 40,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  ratingWidget: RatingWidget(
                                    full: Image.asset('${ImagePath.fill_heart}'),
                                    half: SizedBox(),
                                    empty: Image.asset('${ImagePath.empty_heart}'),
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    rateOpportunity(context , rating);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size_H(50),),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }

  SingleChildRenderObjectWidget floatingActionButton(BuildContext context) {
    return isApplied != null && isApplied == true && opportunityStatus == "pending" ?   Padding(
      padding:  EdgeInsets.only(right: size_W(10) , left: size_W(10) , bottom: size_H(15) , top: size_H(15)),
      child: MyLoadingBtn(
        borderRadius: 30,
        width:  size_W(170),
        text: "Get A response?",
        color: Theme_Information.Primary_Color,
        callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {
          MyConfirmationDialog().showConfirmationDialog(
            context: context,
            title: "Confirmation",
            body: "Did you get a response? \n Help us to track your applications",
            cancelBtn: "Rejected",
            saveBtn: "Accepted",
            onSave: (){
              // status
              // accept , reject , pending
              ///
              /// set to accept
              changeStatus(context , "accept");
            },
            onCancel: (){
              // status
              // accept , reject , pending
              ///
              /// set to reject
              changeStatus(context , "reject");
            }
          );
        },
      ),
    ) : SizedBox();
  }

  void changeStatus(BuildContext context ,newStatus ) {
    Provider.of<OpportunityProvider>(context, listen: false).changeStatus(
        apply_opportunity_id: widget.applyOpportunityID!,
        newStatus: newStatus,
        callBack: (){
          EasyLoading.showSuccess("The opportunity status has been successfully changed");
          Provider.of<OpportunityProvider>(context, listen: false).getStatus(opportunity_id: widget.opportunity!.id, callBack: (String? status){

            if(status != null){
              opportunityStatus = status ;
              setState(() {});
            }
          });
        });
  }

  void rateOpportunity(BuildContext context , double rate) {
    MyConfirmationDialog().showConfirmationDialog(
      context: context,
      title: "Confirmation",
      body: "Are you sure you want to rate this opportunity with $rate stars ?",
      saveBtn: "Rate",
      cancelBtn: "Back",
      onSave: () async {
        EasyLoading.show();
        bool isRate = await Provider.of<OpportunityProvider>(context, listen: false).addRate(
            rate: rate.toString(),
                    opportunityId: widget.opportunity!.id)
                .then((value) {
          myRate = rate ;
          EasyLoading.showSuccess("Thanks for your rating");
          setState(() {});
          return true;
        });
      },
    );
  }



  Widget buildRow({required String  image , required String title }) {
    return Padding(
      padding: const EdgeInsets.only(top:2.0 , bottom: 2),
      child: Row(
                  children: [
                    Container(
                        width: size_W(25),
                        child: Image.asset( image, scale: 4)),
                    SizedBox(width: size_W(5),),
                    Text(title , style: ourTextStyle(fontSize: 11 ,fontWeight: FontWeight.w600 , color: Theme_Information.Primary_Color)),
                  ],
                ),
    );
  }

  Widget getSocialImage(String key) {
    // return Text("${item.key}");
    if(key.toLowerCase() == "phone".toLowerCase()){
      return Image.asset(ImagePath.phone , height: size_H(20));
    } else if(key.toLowerCase() == "Email".toLowerCase()){
      return Image.asset(ImagePath.email , height: size_H(20));
    } else if(key.toLowerCase() == "FaceBook".toLowerCase()){
      return Image.asset(ImagePath.facebook , height: size_H(20));
    }else if(key.toLowerCase() == "LinkedIn".toLowerCase()){
      return Image.asset(ImagePath.linkedin , height: size_H(20));
    }else if(key .toLowerCase()== "Instagram".toLowerCase()){
      return Image.asset(ImagePath.instagram , height: size_H(20));
    } else{
      return Image.asset(ImagePath.link , height: size_H(20));
    }

  }
}
