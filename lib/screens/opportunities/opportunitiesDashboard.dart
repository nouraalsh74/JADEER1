import 'dart:developer';
import 'dart:math';

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
import '../../providers/userProvider.dart';
import 'opportunityDetails.dart';

class OpportunitiesDashboard extends StatefulWidget {
  const OpportunitiesDashboard({Key? key}) : super(key: key);

  @override
  State<OpportunitiesDashboard> createState() => _OpportunitiesDashboardState();
}

class _OpportunitiesDashboardState extends State<OpportunitiesDashboard> {
  TextEditingController _searchController = TextEditingController();

  /// Industry
  List<GeneralFireBaseList> allIndustryChips = [];
  GeneralFireBaseList? selectedIndustryChip ;

  /// Location
  List<GeneralFireBaseList> allLocationChips = [];
  GeneralFireBaseList? selectedLocationChip ;


  /// Opportunity type
  List<GeneralFireBaseList> allOpportunityTypeChips = [];
  GeneralFireBaseList? selectedOpportunityTypeChip ;


  /// Availability
  List<GeneralFireBaseList> allAvailabilityChips = [];
  GeneralFireBaseList? selectedAvailabilityChip ;

  

  List<Opportunity> opportunities = [];
  List<Opportunity> opportunitiesBase = [];

  List<Opportunity> filterOpportunitiesByIndustry(GeneralFireBaseList selectedItem) {
    if (selectedItem.name == 'All') {
      return opportunitiesBase; // Return all mentors if 'All' chip is selected
    } else {
      return opportunitiesBase.where((opportunity) => opportunity.industry == selectedItem.name).toList();
    }
  }
  
  List<Opportunity> filterOpportunitiesByLocation(GeneralFireBaseList selectedItem) {
    if (selectedItem.name == 'All') {
      return opportunitiesBase; // Return all mentors if 'All' chip is selected
    } else {
      return opportunitiesBase.where((opportunity) => opportunity.location == selectedItem.name).toList();
    }
  }

  List<Opportunity> filterOpportunitiesByOpportunityType(GeneralFireBaseList selectedItem) {
    if (selectedItem.name == 'All') {
      return opportunitiesBase; // Return all mentors if 'All' chip is selected
    } else {
      return opportunitiesBase.where((opportunity) => opportunity.opportunity_type.contains(selectedItem.name!)).toList();
    }
  }

  List<Opportunity> filterOpportunitiesByAvailability(GeneralFireBaseList selectedItem) {
    if (selectedItem.name == 'All') {
      return opportunitiesBase; // Return all mentors if 'All' chip is selected
    } else {
      return opportunitiesBase.where((opportunity) => opportunity.availability.contains(selectedItem.name!)).toList();
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
      await Provider.of<OpportunityProvider>(context, listen: false).initOpportunity(context) ;

      opportunities = Provider.of<OpportunityProvider>(context, listen: false).opportunityList ;
      opportunitiesBase = opportunities ;
      await Provider.of<OpportunityProvider>(context, listen: false).fetchDataFromFirestoreMyOpportunity("apply_opportunities" , Provider.of<OpportunityProvider>(context, listen: false).myAppliedOpportunity);

      /// Industry
      allIndustryChips.add(GeneralFireBaseList(id: "00" , name: "All"));
      await Provider.of<DataProvider>(context, listen: false).fetchDataFromFirestore("specialties_for_mentors" , allIndustryChips);
      selectedIndustryChip = allIndustryChips.first ;

      /// Location
      allLocationChips.add(GeneralFireBaseList(id: "00" , name: "All"));
      await Provider.of<DataProvider>(context, listen: false).fetchDataFromFirestore("cities" , allLocationChips);
      selectedLocationChip = allLocationChips.first ;
      
      
      /// Availability
      allAvailabilityChips.add(GeneralFireBaseList(id: "00" , name: "All"));
      allAvailabilityChips.add(GeneralFireBaseList(id: "01" , name: "Full-time"));
      allAvailabilityChips.add(GeneralFireBaseList(id: "02" , name: "Part-time"));
      selectedAvailabilityChip = allAvailabilityChips.first ;


      /// Opportunity Type
      allOpportunityTypeChips.add(GeneralFireBaseList(id: "00" , name: "All"));
      allOpportunityTypeChips.add(GeneralFireBaseList(id: "01" , name: "Internship"));
      allOpportunityTypeChips.add(GeneralFireBaseList(id: "02" , name: "Entry-level"));
      allOpportunityTypeChips.add(GeneralFireBaseList(id: "03" , name: "Volunteering"));
      // allOpportunityTypeChips.add(GeneralFireBaseList(id: "04" , name: "Fresh graduate"));
      // allOpportunityTypeChips.add(GeneralFireBaseList(id: "05" , name: "Intern"));
      // allOpportunityTypeChips.add(GeneralFireBaseList(id: "06" , name: "Summer internship"));

      selectedOpportunityTypeChip = allOpportunityTypeChips.first ;


      // opportunities = Provider.of<OpportunityProvider>(context, listen: false).opportunityList ;
      // opportunitiesBase = opportunities ;
      await sortData(context , opportunities, (List<Opportunity> newData){
        opportunities.clear() ;
        opportunitiesBase.clear() ;
        opportunities = newData ;
        opportunitiesBase = List.from(opportunities);
      });

      setState(() {});
      EasyLoading.dismiss();
    });
  }


  String _generateRandomId() {
    var random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(Iterable.generate(10, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }


  void _filterOpportunities(String searchText) {
    setState(() {
      opportunities = opportunitiesBase
          .where((opportunity) =>
      opportunity.title.toLowerCase().contains(searchText.toLowerCase()) ?? false)
          .toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: size_H(280),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Image.asset(ImagePath.mentorsBackground ,height:  size_H(280) , scale: 3 , fit: BoxFit.fill , width: MediaQuery.of(context).size.width),

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

                              SizedBox(height: size_H(10),),
                              Center(
                                child: Container(
                                  height: size_H(45),
                                  decoration: BoxDecoration(
                                    color: Theme_Information.Color_1,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: TextFormField(
                                      controller: _searchController,
                                      onChanged: _filterOpportunities,
                                      decoration: const InputDecoration(
                                        hintText: 'Search...',
                                        border: InputBorder.none, // Removes the default underline
                                        suffixIcon: Icon(Icons.search),
                                      ),
                                    ),
                                  ),
                                ),
                              ),


                              Padding(
                                padding: const EdgeInsets.only( left: 10 , right: 10),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      locationFilter(context),
                                      industryFilter(context),
                                      opportunityTypeFilter(context),
                                      availabilityTypeFilter(context),
                                    ],
                                  ),
                                ),
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
              child: Builder(
                builder: (context) {
                  return Column(
                    children: List.generate(opportunities.length, (index) {
                      final item = opportunities[index];
                      return opportunityItem(opportunity: item);
                    }),
                  );
                }
              ),
            ),
          )



        ],
      ),
    );
  }

  Padding industryFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0 , bottom: 8 , left: 5 , right: 5),
      child: InkWell(
        onTap: () {
          _showBottomSheet(
              context: context,
              setStateB: setState,
              title: "Choose a Industry",
              allChips: allIndustryChips,
              selectedChip: selectedIndustryChip,
              callBack: (selected , selectedItem) {
                selectedIndustryChip = selected ? selectedItem : allIndustryChips.first;
                opportunities = filterOpportunitiesByIndustry(selectedIndustryChip!);
              });
        },
        child: Chip(
          elevation: 0,
          avatar: selectedIndustryChip != null &&
                  selectedIndustryChip != allIndustryChips.first
              ? Icon(Icons.check, color: Theme_Information.Primary_Color)
              : Icon(Icons.add, color: Theme_Information.Color_1),
          backgroundColor: selectedIndustryChip != null &&
                  selectedIndustryChip != allIndustryChips.first
              ? Theme_Information.Color_1
              : Theme_Information.Primary_Color,
          labelStyle: ourTextStyle(
              fontSize: 12,
              color: selectedIndustryChip != null &&
                      selectedIndustryChip != allIndustryChips.first
                  ? Theme_Information.Primary_Color
                  : Theme_Information.Color_1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide.none,
          ),
          label: Text(
            filterLabel(
                title: "Industry",
                allData: allIndustryChips,
                selectedChip: selectedIndustryChip),
            // style: ourTextStyle(),
          ),
        ),
      ),
    );
  }


  Padding opportunityTypeFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0 , bottom: 8 , left: 5 , right: 5),
      child: InkWell(
        onTap: () {
          _showBottomSheet(
              context: context,
              setStateB: setState,
              title: "Choose a Opportunity type",
              allChips: allOpportunityTypeChips,
              selectedChip: selectedOpportunityTypeChip,
              callBack: (selected , selectedItem) {
                selectedOpportunityTypeChip = selected ? selectedItem : allOpportunityTypeChips.first;
                opportunities = filterOpportunitiesByOpportunityType(selectedOpportunityTypeChip!);
              });
        },
        child: Chip(
          elevation: 0,
          avatar: selectedOpportunityTypeChip != null &&
                  selectedOpportunityTypeChip != allOpportunityTypeChips.first
              ? Icon(Icons.check, color: Theme_Information.Primary_Color)
              : Icon(Icons.add, color: Theme_Information.Color_1),
          backgroundColor: selectedOpportunityTypeChip != null &&
                  selectedOpportunityTypeChip != allOpportunityTypeChips.first
              ? Theme_Information.Color_1
              : Theme_Information.Primary_Color,
          labelStyle: ourTextStyle(
              fontSize: 12,
              color: selectedOpportunityTypeChip != null &&
                      selectedOpportunityTypeChip != allOpportunityTypeChips.first
                  ? Theme_Information.Primary_Color
                  : Theme_Information.Color_1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide.none,
          ),
          label: Text(
            filterLabel(
                title: "Opportunity type",
                allData: allOpportunityTypeChips,
                selectedChip: selectedOpportunityTypeChip),
            // style: ourTextStyle(),
          ),
        ),
      ),
    );
  }

  Padding availabilityTypeFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0 , bottom: 8 , left: 5 , right: 5),
      child: InkWell(
        onTap: () {
          _showBottomSheet(
              context: context,
              setStateB: setState,
              title: "Choose a Availability",
              allChips: allAvailabilityChips,
              selectedChip: selectedAvailabilityChip,
              callBack: (selected , selectedItem) {
                selectedAvailabilityChip = selected ? selectedItem : allAvailabilityChips.first;
                opportunities = filterOpportunitiesByAvailability(selectedAvailabilityChip!);
              });
        },
        child: Chip(
          elevation: 0,
          avatar: selectedAvailabilityChip != null &&
              selectedAvailabilityChip != allAvailabilityChips.first
              ? Icon(Icons.check, color: Theme_Information.Primary_Color)
              : Icon(Icons.add, color: Theme_Information.Color_1),
          backgroundColor: selectedAvailabilityChip != null &&
              selectedAvailabilityChip != allAvailabilityChips.first
              ? Theme_Information.Color_1
              : Theme_Information.Primary_Color,
          labelStyle: ourTextStyle(
              fontSize: 12,
              color: selectedAvailabilityChip != null &&
                  selectedAvailabilityChip != allAvailabilityChips.first
                  ? Theme_Information.Primary_Color
                  : Theme_Information.Color_1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide.none,
          ),
          label: Text(
            filterLabel(
                title: "Availability",
                allData: allAvailabilityChips,
                selectedChip: selectedAvailabilityChip),
            // style: ourTextStyle(),
          ),
        ),
      ),
    );
  }


  Padding locationFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0 , bottom: 8 , left: 5 , right: 5),
      child: InkWell(
        onTap: () {
          _showBottomSheet(
              context: context,
              setStateB: setState,
              title: "Choose a Location",
              allChips: allLocationChips,
              selectedChip: selectedLocationChip,
              callBack: (selected , selectedItem) {
                selectedLocationChip = selected ? selectedItem : allLocationChips.first;
                opportunities = filterOpportunitiesByLocation(selectedLocationChip!);
                print("opportunities ${opportunities.length}");
              });
        },
        child: Chip(
          elevation: 0,
          avatar: selectedLocationChip != null &&
                  selectedLocationChip != allLocationChips.first
              ? Icon(Icons.check, color: Theme_Information.Primary_Color)
              : Icon(Icons.add, color: Theme_Information.Color_1),
          backgroundColor: selectedLocationChip != null &&
                  selectedLocationChip != allLocationChips.first
              ? Theme_Information.Color_1
              : Theme_Information.Primary_Color,
          labelStyle: ourTextStyle(
              fontSize: 12,
              color: selectedLocationChip != null &&
                      selectedLocationChip != allLocationChips.first
                  ? Theme_Information.Primary_Color
                  : Theme_Information.Color_1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide.none,
          ),
          label: Text(
            filterLabel(
                title: "Location",
                allData: allLocationChips,
                selectedChip: selectedLocationChip),
            // style: ourTextStyle(),
          ),
        ),
      ),
    );
  }

  String filterLabel(
      {GeneralFireBaseList? selectedChip,
      required List<GeneralFireBaseList> allData,
        required String title}) {
    if(selectedChip == null || selectedChip == allData.first ){
      return title ;
    } else{
      return selectedChip.name ?? title ;
    }
  }


  void _showBottomSheet({required BuildContext context ,required StateSetter setStateB ,
    required Function(bool selected ,GeneralFireBaseList selectedItem) callBack ,
    required String title,
    required List<GeneralFireBaseList> allChips,
    required GeneralFireBaseList? selectedChip
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme_Information.Primary_Color,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: size_H(300),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: size_H(10),),
                    Text("$title", style: ourTextStyle(color: Theme_Information.Color_1 , fontSize: 17),),
                    SizedBox(height: size_H(5),),
                    const Padding(
                      padding: EdgeInsets.only(right: 15.0 , left: 15),
                      child: Divider(),
                    ),
                    SizedBox(height: size_H(5),),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: allChips.map((selectedItem) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ChoiceChip(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: BorderSide.none,
                                ),
                                elevation: 0 ,
                                backgroundColor: selectedChip == selectedItem
                                    ? Theme_Information.Color_1
                                    : Theme_Information.Primary_Color,
                                labelStyle: ourTextStyle(
                                    fontSize: 12,
                                    color: selectedChip == selectedItem
                                        ? Theme_Information.Primary_Color
                                        : Theme_Information.Color_1
                                ),
                                label: Text("${selectedItem.name}"  ),
                                selected: selectedChip == selectedItem,
                                onSelected: (bool selected) {
                                setState(() {
                                  setStateB(() {
                                    selectedChip = selected ? selectedItem : allChips.first;
                                    callBack(selected , selectedItem);
                                  });
                                });
                      
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }
  



  Padding opportunityItem({required Opportunity opportunity }) {
    return Padding(
      padding: const EdgeInsets.only(left: 15  , right: 15 , bottom: 5),
      child: GestureDetector(
        onTap: (){
          // MentorDetailsPage
          Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => OpportunityDetailsPage(opportunity: opportunity ,similarity: opportunity.similarity, ))).then((value) async {
            await Provider.of<OpportunityProvider>(context, listen: false).fetchDataFromFirestoreMyOpportunityForApply("apply_opportunities");
            setState(() {});
          });
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${opportunity.title}" , maxLines: 1 , overflow: TextOverflow.ellipsis , style: ourTextStyle(fontSize: 12,color: Theme_Information.Primary_Color, fontWeight: FontWeight.w600)),
                            Text("${opportunity.company}" , style: ourTextStyle(fontSize: 9 ,color: Theme_Information.Primary_Color ,  fontWeight: FontWeight.w400)),
                            Text("${opportunity.location}" , style: ourTextStyle(fontSize: 9 ,color: Theme_Information.Primary_Color ,  fontWeight: FontWeight.w400)),
                          ],
                        ),
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

                      if(!isApplied(opportunity))
                      Text("• Not Applied" , style: ourTextStyle(color: Theme_Information.Color_7 , fontSize: 9),),

                      if(isApplied(opportunity))
                        Text("* Applied" , style: ourTextStyle(fontSize: 9 , color: Theme_Information.Color_12),),


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


  bool isSaved(Opportunity opportunity) => Provider.of<OpportunityProvider>(context, listen: true).isOpportunitySaved(opportunity: opportunity) == true;
  bool isApplied(Opportunity opportunity) => Provider.of<OpportunityProvider>(context, listen: true).isOpportunityApplied(opportunity: opportunity) == true;




}

/// calculateSimilarity

Future sortData(context , List<Opportunity> data , Function(List<Opportunity> data) callBack) async {
  // User information
  // List<String> userSkill = ['Analytical Thinking', 'Communication', 'Adaptability'];
  // List<String> userIntereset =['Leadership', 'Communication', 'Adaptability'];
  List<String> userSkill = Provider.of<UserProvider>(context, listen: false).userProfile?.skills??[] ;
  List<String> userInterests = Provider.of<UserProvider>(context, listen: false).userProfile?.interests??[] ;
  List<String> userFieldsOfStudy = [Provider.of<UserProvider>(context, listen: false).userProfile!.experience!.name!];


  List<String> userSkills = userSkill + userInterests;
  // print(userSkills);
  // List<String> userFieldsOfStudy = ['Computer Science'];

  // Calculate job similarity scores
  List<JobSimilarity> jobSimilarities = calculateJobSimilarities(userSkills, userFieldsOfStudy, data);

  // Sort jobs based on similarity scores in descending order
  jobSimilarities.sort((a, b) => b.similarity.compareTo(a.similarity));


  callBack(jobSimilarities.map((jobSimilarity) => jobSimilarity.job).toList());

  // Print job similarity scores
  for (var similarity in jobSimilarities) {
    print('Job ID: ${similarity.job.id} - Similarity: ${similarity.similarity.toStringAsFixed(2)}%');
  }
}


class JobSimilarity {
  final Opportunity job;
  final double similarity;

  JobSimilarity({required this.job, required this.similarity});
}

List<JobSimilarity> calculateJobSimilarities(
    List<String> userSkills, List<String> userFieldsOfStudy, List<Opportunity> jobs) {
  List<JobSimilarity> jobSimilarities = [];

  for (var job in jobs) {
    double similarity = calculateSimilarity(userSkills, userFieldsOfStudy, job.skills??[], job.fieldsOfStudy??[]);
    job.similarity = "$similarity" ;
    jobSimilarities.add(JobSimilarity(job: job, similarity: similarity));
  }

  return jobSimilarities;
}

double calculateSimilarity(
    List<String> userSkills, List<String> userFieldsOfStudy, List<String> jobSkills, List<String> jobFieldsOfStudy) {
  double skillSimilarity = calculateSkillSimilarity(userSkills, jobSkills);
  double fieldOfStudySimilarity = calculateFieldOfStudySimilarity(userFieldsOfStudy, jobFieldsOfStudy);

  // You can adjust the weights for skill similarity and field of study similarity based on your requirements
  double similarity = (0.3 * skillSimilarity) + (0.7 * fieldOfStudySimilarity);

  return similarity;
}

double calculateSkillSimilarity(List<String> userSkills, List<String> jobSkills) {
  // Convert the skills to sets to remove duplicates
  Set<String> userSkillSet = userSkills.toSet();
  Set<String> jobSkillSet = jobSkills.toSet();

  // Calculate the intersection of skills
  Set<String> commonSkills = userSkillSet.intersection(jobSkillSet);

  // Calculate the Jaccard similarity coefficient
  double similarity = commonSkills.length / (userSkillSet.length + jobSkillSet.length - commonSkills.length);

  return similarity;
}

double calculateFieldOfStudySimilarity(List<String> userFieldsOfStudy, List<String> jobFieldsOfStudy) {
  // Check if there is any common field of study
  bool hasCommonFieldOfStudy = userFieldsOfStudy.any((userField) => jobFieldsOfStudy.contains(userField));

  if (hasCommonFieldOfStudy) {
    return 1.0;
  } else {
    return 0.0;
  }
}
