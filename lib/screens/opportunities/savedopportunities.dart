import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../commonWidgets/backIcon.dart';
import '../../configuration/images.dart';
import '../../configuration/theme.dart';
import '../../models/opportunityModel.dart';
import '../../models/savedOpportunityModel.dart';
import '../../providers/dataProvider.dart';
import '../../providers/opportunityProvider.dart';
import 'opportunityDetails.dart';

class SavedOpportunities extends StatefulWidget {
  const SavedOpportunities({Key? key}) : super(key: key);

  @override
  State<SavedOpportunities> createState() => _SavedOpportunitiesState();
}

class _SavedOpportunitiesState extends State<SavedOpportunities> {

  // List<Opportunity> opportunities = [];
  List<SavedOpportunity> savedOpportunities = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      EasyLoading.show();
      // opportunities.clear();
      savedOpportunities.clear();
      savedOpportunities =  Provider.of<OpportunityProvider>(context, listen: false).savedOpportunityList;
      // await Provider.of<OpportunityProvider>(context, listen: false).fetchDataFromFirestoreSavedOpportunity("saved_opportunities" , savedOpportunities);
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
                              SizedBox(height: size_H(20)),
                              Row(
                                children: [
                                  SizedBox(width: size_W(40)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Saved" , style: ourTextStyle(fontSize: 25 , color: Theme_Information.Color_1),),
                                      Text("Opportunities" , style: ourTextStyle(fontSize: 25 , color: Theme_Information.Color_1),),
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

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(savedOpportunities.length, (index) {
                  final item = savedOpportunities[index];
                  return opportunityItem(savedOpportunity: item);
                }),
              ),
            ),
          )



        ],
      ),
    );
  }
  Padding opportunityItem({required SavedOpportunity savedOpportunity}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15  , right: 15 , bottom: 5),
      child: GestureDetector(
        onTap: (){
          // MentorDetailsPage
          Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => OpportunityDetailsPage(opportunity: savedOpportunity.opportunity ,)));
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
                          child: Image.network("${savedOpportunity.opportunity?.company_image}" ,
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
                          Text("${savedOpportunity.opportunity?.title}" , style: ourTextStyle(fontSize: 12,color: Theme_Information.Primary_Color, fontWeight: FontWeight.w600)),
                          Text("${savedOpportunity.opportunity?.company}" , style: ourTextStyle(fontSize: 9 ,color: Theme_Information.Primary_Color ,  fontWeight: FontWeight.w400)),
                          Text("${savedOpportunity.opportunity?.location}" , style: ourTextStyle(fontSize: 9 ,color: Theme_Information.Primary_Color ,  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15 , left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          EasyLoading.show();
                          await Provider.of<OpportunityProvider>(context, listen: false).removeItem(opportunity_id: savedOpportunity.opportunity!.id , context: context);
                          setState(() {});
                          EasyLoading.dismiss();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0 , left: 8 , top: 8),
                          child: Icon(Icons.bookmark , size: 20 , color: Theme_Information.Primary_Color),
                        ),
                      ),
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


}
