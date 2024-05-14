import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../../commonWidgets/backIcon.dart';
import '../../configuration/images.dart';
import '../../configuration/theme.dart';
import '../../models/myOpportunityModel.dart';
import '../../providers/opportunityProvider.dart';

class MyActivityDashboard extends StatefulWidget {
  const MyActivityDashboard({Key? key}) : super(key: key);

  @override
  State<MyActivityDashboard> createState() => _MyActivityDashboardState();
}

class _MyActivityDashboardState extends State<MyActivityDashboard> {
  List<MyAppliedOpportunity> myApplyOpportunityNow = [];
  int? allApplicationsNow ;
  int? applicationsRejectNow ;
  int? applicationsAcceptNow ;

  List<MyAppliedOpportunity> myApplyOpportunityLast = [];
  int? allApplicationsLast ;
  int? applicationsRejectLast ;
  int? applicationsAcceptLast ;

  double? percentageChangeAccepted ;
  double? percentageChangeRejected ;
  double? percentageChangeTotalApplications ;
  double? percentageAcceptedNow  ;
  Map<String, double> dataMap = {
    "Technology": 0,
    "Finance & Accounting": 0,
    "Marketing": 0,
    "Human Resources": 0,
    "Engineering": 0,
    "Others": 0,
  };
  final colorList = <Color>[
    const Color(0xff012269),
    const Color(0xff344F87),
    const Color(0xff6080C5),
    const Color(0xff99AFDF),
    const Color(0xffC9D5ED),
    const Color(0xff9DBEFF),

  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      EasyLoading.show();
      myApplyOpportunityNow.clear();
      myApplyOpportunityLast.clear();
      await Provider.of<OpportunityProvider>(context, listen: false).fetchDataFromFirestoreMyOpportunityThisMonth("apply_opportunities" , myApplyOpportunityNow);
      await Provider.of<OpportunityProvider>(context, listen: false).fetchDataFromFirestoreMyOpportunityLastMonth("apply_opportunities" , myApplyOpportunityLast);




      getPercentageData();

      getIndustryChartData();

      setState(() {});
      EasyLoading.dismiss();
    });
  }

  Future getPercentageData() async {
    allApplicationsNow = myApplyOpportunityNow.length ;
    applicationsRejectNow = (myApplyOpportunityNow.where((element) => element.status == "reject").toList()).length ;
    applicationsAcceptNow = (myApplyOpportunityNow.where((element) => element.status == "accept").toList()).length ;

    allApplicationsLast = myApplyOpportunityLast.length ;
    applicationsRejectLast = (myApplyOpportunityLast.where((element) => element.status == "reject").toList()).length ;
    applicationsAcceptLast = (myApplyOpportunityLast.where((element) => element.status == "accept").toList()).length ;
    percentageAcceptedNow = calculatePercentage(applicationsAcceptNow, applicationsRejectNow, allApplicationsNow);
    percentageChangeAccepted = calculatePercentageChange(applicationsAcceptNow, applicationsAcceptLast);
    percentageChangeRejected = calculatePercentageChange(applicationsRejectNow, applicationsRejectLast);
    percentageChangeTotalApplications = calculatePercentageChange(allApplicationsNow, allApplicationsLast);

  }

  Future getIndustryChartData()  async {
    dataMap["Technology"] = ((myApplyOpportunityNow.where((element) => element.opportunity!.industry.toLowerCase().contains("Technology".toLowerCase())).toList()).length).toDouble() ;
    dataMap["Finance & Accounting"] = ((myApplyOpportunityNow.where((element) => element.opportunity!.industry.toLowerCase().contains("Finance & Accounting".toLowerCase())).toList()).length).toDouble() ;
    dataMap["Marketing"] = ((myApplyOpportunityNow.where((element) => element.opportunity!.industry.toLowerCase().contains("Marketing".toLowerCase())).toList()).length).toDouble() ;
    dataMap["Human Resources"] = ((myApplyOpportunityNow.where((element) => element.opportunity!.industry.toLowerCase().contains("Human Resources".toLowerCase())).toList()).length).toDouble() ;
    dataMap["Engineering"] = ((myApplyOpportunityNow.where((element) => element.opportunity!.industry.toLowerCase().contains("Engineering".toLowerCase())).toList()).length).toDouble() ;

    double total = dataMap["Technology"]!
        + dataMap["Finance & Accounting"]!
        + dataMap["Marketing"]!
        + dataMap["Human Resources"]!
        + dataMap["Engineering"]!;
    dataMap["Others"] = myApplyOpportunityNow.length.toDouble() - total ;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: size_H(200),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Image.asset(ImagePath.mentorsBackground ,height:  size_H(250) , scale: 3 , fit: BoxFit.fill , width: MediaQuery.of(context).size.width),

                      Positioned.fill(
                        top: size_H(20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BackIcon(
                                padding: EdgeInsets.only(top: 8 , right: 8 , left: 8 ),
                                backWidget: Image.asset(ImagePath.backBtn , color: Colors.white , scale: 3),
                              ),
                              SizedBox(height: size_H(20)),
                              Row(
                                children: [
                                  SizedBox(width: size_W(40)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Dashboard",
                                        style: ourTextStyle(
                                            fontSize: 25,
                                            color: Theme_Information.Color_1),
                                      ),
                                      SizedBox(height: size_H(5),),
                                      Text(
                                        "Your activity during the month",
                                        style: ourTextStyle(
                                            fontSize: 15,
                                            color: Theme_Information.Color_7),
                                      ),
                                      SizedBox(height: size_H(10),),
                                    ],
                                  ),
                                ],
                              ),


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
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCard(cardImage: ImagePath.document , cardName: "Applications" , cardNumber: "${allApplicationsNow?? '-'}" ,percentage:  percentageChangeTotalApplications??0.0),
                buildCard(cardImage: ImagePath.approvedIcon , cardName: "Accepted" , cardNumber: "${applicationsAcceptNow?? '-'}",percentage:  percentageChangeAccepted??0.0),
                buildCard(cardImage: ImagePath.rejectedIcon , cardName: "Rejected" , cardNumber: "${applicationsRejectNow?? '-'}",percentage:  percentageChangeRejected??0.0),
              ],
            ),
          ) ,
          SizedBox(height: size_H(20),),
          Padding(
            padding: const EdgeInsets.only(left: 8.0 , right: 8),
            child: Stack(
              children: [
                Image.asset(ImagePath.successfulApplicationIcon),
                if(percentageAcceptedNow != null)
                  Positioned.fill(
                    left: size_W(120),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check,
                                      color: Theme_Information.Gray_Color),
                                  SizedBox(width: size_W(7),),
                                  Text(
                                      "${percentageAcceptedNow?.toStringAsFixed(0)}%",
                                      style: ourTextStyle(
                                            fontSize: 18,
                                          color: Theme_Information.Color_1)),
                                ],
                              ),
                              Text(
                                  "Successful application rate",
                                  style: ourTextStyle(color: Theme_Information.Gray_Color)),
                            ],
                          ))),
              ],
            ),
          ),
          SizedBox(height: size_H(20),),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(right:16.0 , left: 16 , bottom: 8 , top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Most suggested industries:" , style: ourTextStyle(),),
                  SizedBox(height: size_H(10),),
                  PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 3.5,
                    colorList: colorList,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    centerWidget: Image.asset(ImagePath.mostSuggestedIndustries  , scale: 4),
                    ringStrokeWidth: 10,
                    legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendShape: BoxShape.rectangle,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendTextStyle: ourTextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11
                      ),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: false,
                      showChartValues: false,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Card buildCard({
    required String cardName ,
    required String cardNumber ,
    required String cardImage ,
    required double percentage ,
  }) {
    return Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: SizedBox(
                  height: size_H(110),
                  width: size_H(110),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child:  Align(
                              alignment: Alignment.topRight,
                              child: buildColumnPercentage(percentage)),
                        ),
                        Positioned.fill(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(cardImage , scale: 3),
                            SizedBox(height: size_H(2),),
                            Text("$cardNumber" , style: ourTextStyle(fontSize: 22 ,color: Theme_Information.Primary_Color )),
                            SizedBox(height: size_H(2),),
                            Text("$cardName" , style: ourTextStyle(fontSize: 11 ,color: Theme_Information.Primary_Color )),
                          ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }

  Column buildColumnPercentage(double percentage) {
    bool? isPositive ;
    if(percentage > 0){
      isPositive = true ;
    } else if(percentage < 0){
      isPositive = false ;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isPositive != null && isPositive == true)
          Icon(Icons.keyboard_arrow_up_outlined,
              color: Theme_Information.Color_12),
        if (isPositive != null && isPositive == false)
          Icon(Icons.keyboard_arrow_down_outlined,
              color: Theme_Information.Color_10),
        if (isPositive != null)
          Text("${percentage.toStringAsFixed(0)}%",
              style: ourTextStyle(
                  fontSize: 9,
                  color: isPositive
                      ? Theme_Information.Color_12
                      : Theme_Information.Color_10)),
      ],
    );
  }

  double calculatePercentage(int? accepted, int? rejected, int? total) {
    if (total == 0) {
      return 0.0;
    }
    return (accepted!) / total!.toDouble() * 100;
  }

  double calculatePercentageChange(int? thisMonth, int? lastMonth) {
    if (lastMonth == 0) {
      return 0.0;
    }
    return ((thisMonth! - lastMonth!) / lastMonth.toDouble()) * 100;
  }

}
