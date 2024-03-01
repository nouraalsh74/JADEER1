import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/images.dart';
import 'package:flutter_application_2/configuration/theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../commonWidgets/backIcon.dart';
import '../../models/mentorsModel.dart';
import '../../providers/DataProvider.dart';
import 'mentorsDetails.dart';

class MentorsDashBoard extends StatefulWidget {
  const MentorsDashBoard({Key? key}) : super(key: key);

  @override
  State<MentorsDashBoard> createState() => _MentorsDashBoardState();
}

class _MentorsDashBoardState extends State<MentorsDashBoard> {
  List<String> allChips = ['All', 'HR', 'Accounting', 'Information Systems'];
  String selectedChip = 'All';

  List<Mentor> mentors = [];
  List<Mentor> mentorsBase = [];

  List<Mentor> filterMentorsByMajor(String major) {
    if (major == 'All') {
      return mentorsBase; // Return all mentors if 'All' chip is selected
    } else {
      return mentorsBase.where((mentor) => mentor.major == major).toList();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      EasyLoading.show();
      mentorsBase.clear();
      mentors.clear();
      await Provider.of<DataProvider>(context, listen: false).fetchDataFromFirestoreMentor("mentors" , mentors);
      mentorsBase = mentors ;
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
                                      Text("Mentors" , style: ourTextStyle(fontSize: 25 , color: Theme_Information.Color_1),),
                                      Text("Connect with a mentor" , style: ourTextStyle(color: Theme_Information.Color_3 , fontSize: 11),),
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
                                              label: Text(chip),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25.0),
                                                side: BorderSide.none,
                                              ),
                                              selected: selectedChip == chip,
                                              onSelected: (selected) {
                                                setState(() {
                                                  selectedChip = selected ? chip : 'All';
                                                  mentors = filterMentorsByMajor(selectedChip);
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
                children: List.generate(mentors.length, (index) {
                  final item = mentors[index];
                  return mentorsItem(
                      mentor: item
                  );
                }),
              ),
            ),
          )
          

            
        ],
      ),
    );
  }

  Padding mentorsItem({required Mentor mentor}) {
    return Padding(
                  padding: const EdgeInsets.only(left: 15  , right: 15 , bottom: 5),
                  child: GestureDetector(
                    onTap: (){
                      // MentorDetailsPage
                      Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => MentorDetailsPage(mentor: mentor ,)));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Image.network("${mentor.image}" ,
                                    // child: Image.network("https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg" ,
                                        fit: BoxFit.cover,
                                        width: size_H(65),
                                        height: size_H(65),
                                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace,){
                                          return Image.network("https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg" ,
                                            width: size_H(65),
                                            height: size_H(65),
                                            fit: BoxFit.cover,
                                          );
                                        },
                                    )),
                                SizedBox(width: size_W(10)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${mentor.name}" , style: ourTextStyle(fontSize: 14,color: Theme_Information.Primary_Color, fontWeight: FontWeight.w600)),
                                    Text("${mentor.major}" , style: ourTextStyle(fontSize: 12 ,color: Theme_Information.Primary_Color ,  fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Icon(Icons.arrow_forward_ios , size: 20 , color: Theme_Information.Primary_Color),
                            )

                          ],
                        ),
                      ),
                    ),
                  ),
                );
  }
}

/*
id
name
industry
contact information

 */