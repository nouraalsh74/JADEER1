import 'package:flutter/material.dart';

import '../../commonWidgets/backIcon.dart';
import '../../configuration/images.dart';
import '../../configuration/theme.dart';
import '../../models/mentorsModel.dart';

class MentorDetailsPage extends StatefulWidget {
  const MentorDetailsPage({Key? key , this.mentor}) : super(key: key);
  final Mentor? mentor ;
  @override
  State<MentorDetailsPage> createState() => _MentorDetailsPageState();
}

class _MentorDetailsPageState extends State<MentorDetailsPage> {
  bool showAllLines = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              child: Image.network(widget.mentor!.image , width: size_H(90) , height: size_H(90) ,
                                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace,){
                                  return Image.network("https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg" ,
                                    width: size_H(90) , height: size_H(90),
                                    fit: BoxFit.cover,
                                  );
                                },
                              )),
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
                Text("${widget.mentor!.name}" , style: ourTextStyle(fontSize: 22 ,fontWeight: FontWeight.w600 , color: Theme_Information.Primary_Color)),
                Text("${widget.mentor!.major}" , style: ourTextStyle(fontSize: 12, color: Theme_Information.Primary_Color)),
                
                SizedBox(height: size_H(40),),

                Text("About the mentor" , style: ourTextStyle(fontSize: 14, color: Theme_Information.Primary_Color , fontWeight: FontWeight.w600)),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${widget.mentor!.description}" , maxLines: showAllLines ? 70 : 4 , overflow: TextOverflow.ellipsis   ,style: ourTextStyle(fontSize: 12, color: Theme_Information.Primary_Color)),
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
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size_H(20),),
                Text("Contact the mentor" , style: ourTextStyle(fontSize: 14, color: Theme_Information.Primary_Color , fontWeight: FontWeight.w600)),
                SizedBox(height: size_H(10),),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    border: Border.all(
                      color: Theme_Information.Color_7!,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: List.generate(widget.mentor!.socialMedia.entries.toList().length, (index) {
                        final item = widget.mentor!.socialMedia.entries.toList()[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 3 , bottom: 3),
                          child: item.value.isEmpty ? SizedBox() : Row(
                            children: [
                              Container(width: size_W(35), child: getSocialImage(item.key)),
                              Container(child: Text("${item.value}" , style: ourTextStyle(fontSize: 11),)),
                            ],
                          ),
                        );
                      },)
                    ),
                  ),
                )

              ],
            ),
          )
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
