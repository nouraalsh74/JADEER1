// myApplyOpportunity


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../commonWidgets/backIcon.dart';
import '../../configuration/images.dart';
import '../../configuration/theme.dart';
import '../../models/myOpportunityModel.dart';
import '../../models/opportunityModel.dart';
import '../../models/savedOpportunityModel.dart';
import '../../providers/dataProvider.dart';
import '../../providers/opportunityProvider.dart';
import 'opportunityDetails.dart';

class MyApplyOpportunity extends StatefulWidget {
  const MyApplyOpportunity({Key? key}) : super(key: key);

  @override
  State<MyApplyOpportunity> createState() => _MyApplyOpportunityState();
}

class _MyApplyOpportunityState extends State<MyApplyOpportunity> {
  List<MyAppliedOpportunity> myApplyOpportunity = [];
  List<MyAppliedOpportunity> _filteredOpportunities = [];
  TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      EasyLoading.show();
      // opportunities.clear();
      myApplyOpportunity.clear();
      await Provider.of<OpportunityProvider>(context, listen: false).fetchDataFromFirestoreMyOpportunity("apply_opportunities" , myApplyOpportunity);
      _filteredOpportunities = myApplyOpportunity ;
      setState(() {});
      EasyLoading.dismiss();
    });
  }

  void _filterOpportunities(String searchText) {
    setState(() {
      _filteredOpportunities = myApplyOpportunity
          .where((opportunity) =>
      opportunity.opportunity?.title.toLowerCase().contains(searchText.toLowerCase()) ?? false)
          .toList();
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
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Applications",
                                        style: ourTextStyle(
                                            fontSize: 25,
                                            color: Theme_Information.Color_1),
                                      ),
                                      SizedBox(height: size_H(10),),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme_Information.Color_1,
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        width: MediaQuery.of(context).size.width * 0.8,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: TextFormField(

                                            controller: _searchController,
                                            onChanged: _filterOpportunities,
                                            decoration: const InputDecoration(
                                              // contentPadding: EdgeInsets.only(right: 0.0 , top: 0 , bottom: 0),
                                              hintText: 'Search...',
                                              border: InputBorder.none, // Removes the default underline
                                              suffixIcon: Icon(Icons.search),
                                            ),
                                          ),
                                        ),
                                      )
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
                children: List.generate(_filteredOpportunities.length, (index) {
                  final item = _filteredOpportunities[index];
                  return opportunityItem(savedOpportunity: item);
                }),
              ),
            ),
          )



        ],
      ),
    );
  }
  Padding opportunityItem({required MyAppliedOpportunity savedOpportunity}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15  , right: 15 , bottom: 5),
      child: GestureDetector(
        onTap: (){
          // MentorDetailsPage
          Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => OpportunityDetailsPage(opportunity: savedOpportunity.opportunity ,)));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
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
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0 , left: 8 , top: 8),
                      child: Icon(Icons.arrow_forward_ios , size: 20 ,   color: Theme_Information.Primary_Color),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }


}
