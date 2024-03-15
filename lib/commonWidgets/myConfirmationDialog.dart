import 'package:flutter/material.dart';

import '../configuration/theme.dart';

class MyConfirmationDialog{
  Future<bool?> showConfirmationDialog(
      {
        required BuildContext context,
        required String title,
        required String body,
        Function? onSave,
        Function? onCancel,
        String? cancelBtn,
        String? saveBtn
      }) async {
    return showDialog(
      context: context,
      builder: (BuildContext contextB) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(top: 10.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          // title: Text('Confirmation' , style: ourTextStyle(fontSize: 17 , fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: size_H(10),),
              Padding(
                padding: const EdgeInsets.only(right: 8.0 , left: 8.0),
                child: Center(child: Text('${title}' , style: ourTextStyle(fontSize: 17 , fontWeight: FontWeight.bold))),
              ),

              SizedBox(height: size_H(10),),

              Padding(
                padding: const EdgeInsets.only(right: 8.0 , left: 8.0),
                child: Container(child: Text("${body}" ,textAlign: TextAlign.center, style: ourTextStyle(),)),
              ),


              SizedBox(height: size_H(30),),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        // Navigator.of(context).pop(true); // User

                        if(onCancel!= null) {
                          Navigator.of(contextB).pop();
                          onCancel();
                        } else{
                          Navigator.of(contextB).pop();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        decoration: BoxDecoration(
                          color: Theme_Information.Color_10,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32.0),
                              bottomRight: Radius.circular(0.0)),
                        ),
                        child:  Text(
                          cancelBtn??"Cancel",
                          style:ourTextStyle(color: Theme_Information.Color_1),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        if(onSave!= null) {
                          onSave();
                          Navigator.of(contextB).pop();
                        } else{
                          Navigator.of(contextB).pop();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                        decoration: BoxDecoration(
                          color: Theme_Information.Primary_Color,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(32.0)),
                        ),
                        child: Text(
                          saveBtn ?? "Save",
                          style: ourTextStyle(color: Theme_Information.Color_1),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        );
      },
    );
  }
}