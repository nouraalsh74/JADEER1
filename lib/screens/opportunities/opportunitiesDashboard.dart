import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/generalListFireBase.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../commonWidgets/backIcon.dart';
import '../../configuration/images.dart';
import '../../configuration/theme.dart';
import '../../models/opportunityModel.dart';
import '../../providers/dataProvider.dart';
import '../../providers/opportunityProvider.dart';
import 'opportunityDetails.dart';

class OpportunitiesDashboard extends StatefulWidget {
  const OpportunitiesDashboard({Key? key}) : super(key: key);

  @override
  State<OpportunitiesDashboard> createState() => _OpportunitiesDashboardState();
}

class _OpportunitiesDashboardState extends State<OpportunitiesDashboard> {

  // List<String> allChips = ['All', 'HR', 'Accounting', 'Information Systems'];
  List<GeneralFireBaseList> allChips = [];
  GeneralFireBaseList? selectedChip ;

  List<Opportunity> opportunities = [];
  List<Opportunity> opportunitiesBase = [];

  List<Opportunity> filterMentorsByMajor(GeneralFireBaseList industry) {
    if (industry.name == 'All') {
      return opportunitiesBase; // Return all mentors if 'All' chip is selected
    } else {
      return opportunitiesBase.where((opportunity) => opportunity.industry == industry.name).toList();
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    Future.delayed(Duration.zero, () async {
      EasyLoading.show();
      opportunitiesBase.clear();
      opportunities.clear();
      opportunities = Provider.of<OpportunityProvider>(context, listen: false).opportunityList ;
      opportunitiesBase = opportunities ;
      allChips.add(GeneralFireBaseList(id: "00" , name: "All"));
      await Provider.of<DataProvider>(context, listen: false).fetchDataFromFirestore("specialties_for_opportunities" , allChips);
      selectedChip = allChips.first ;
      setState(() {});
      EasyLoading.dismiss();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: size_H(250),
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

                              Row(
                                children: [
                                  SizedBox(width: size_W(40)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Opportunities" , style: ourTextStyle(fontSize: 25 , color: Theme_Information.Color_1),),
                                      Text("Tailored to your needs" , style: ourTextStyle(color: Theme_Information.Color_3 , fontSize: 11),),
                                    ],
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0 , left: 15 , right: 15 , top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: Text("Industries" , style: ourTextStyle(fontSize: 12 , color: Theme_Information.Color_1),),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: allChips.map((chip) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 2.0 , left: 2.0),
                                            child: ChoiceChip(
                                              elevation: 0 ,
                                              backgroundColor: selectedChip == chip
                                                  ? Theme_Information.Color_1
                                                  : Theme_Information.Primary_Color,
                                              labelStyle: ourTextStyle(
                                                  fontSize: 12,
                                                  color: selectedChip == chip
                                                      ? Theme_Information.Primary_Color
                                                      : Theme_Information.Color_1
                                              ),
                                              label: Text("${chip.name}"),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25.0),
                                                side: BorderSide.none,
                                              ),
                                              selected: selectedChip == chip,
                                              onSelected: (selected) {
                                                setState(() {
                                                  selectedChip = selected ? chip : allChips.first;
                                                  // selectedChip = selected ? chip : 'All';
                                                  opportunities = filterMentorsByMajor(selectedChip!);
                                                });
                                              },
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              )

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

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(opportunities.length, (index) {
                  final item = opportunities[index];
                  return opportunityItem(opportunity: item);
                }),
              ),
            ),
          )



        ],
      ),
    );
  }
  Padding opportunityItem({required Opportunity opportunity}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15  , right: 15 , bottom: 5),
      child: GestureDetector(
        onTap: (){
          // MentorDetailsPage
          Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => OpportunityDetailsPage(opportunity: opportunity ,)));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.network("${opportunity.company_image}" ,
                            // child: Image.network("https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg" ,
                            fit: BoxFit.cover,
                            width: size_H(80),
                            height: size_H(65),
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace,){
                              return Image.network("https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg" ,
                                width: size_H(80),
                                height: size_H(65),
                                fit: BoxFit.cover,
                              );
                            },
                          )),
                      SizedBox(width: size_W(10)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${opportunity.title}" , style: ourTextStyle(fontSize: 12,color: Theme_Information.Primary_Color, fontWeight: FontWeight.w600)),
                          Text("${opportunity.company}" , style: ourTextStyle(fontSize: 9 ,color: Theme_Information.Primary_Color ,  fontWeight: FontWeight.w400)),
                          Text("${opportunity.location}" , style: ourTextStyle(fontSize: 9 ,color: Theme_Information.Primary_Color ,  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10 , left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if(!isSaved(opportunity))
                      InkWell(
                        onTap: () async {
                          EasyLoading.show();
                          await Provider.of<OpportunityProvider>(context, listen: false).addOpportunityToSaved(opportunity , context);
                          setState(() {});
                          EasyLoading.dismiss();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0 , left: 8 , top: 8),
                          child: Icon(Icons.bookmark_border , size: 20 , color: Theme_Information.Primary_Color),
                        ),
                      ),

                      if(isSaved(opportunity))
                        InkWell(
                          onTap: () async {
                            EasyLoading.show();
                            await Provider.of<OpportunityProvider>(context, listen: false).removeItem(opportunity_id: opportunity.id , context: context);
                            setState(() {});
                            EasyLoading.dismiss();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0 , left: 8 , top: 8),
                            child: Icon(Icons.bookmark , size: 20 , color: Theme_Information.Primary_Color),
                          ),
                        ),

                      SizedBox(height: size_H(5),),

                      Text("• Not Applied" , style: TextStyle(color: Theme_Information.Color_7 , fontSize: 9),),

                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isSaved(Opportunity opportunity) => Provider.of<OpportunityProvider>(context, listen: false).isOpportunitySaved(opportunity: opportunity) == true;





}
