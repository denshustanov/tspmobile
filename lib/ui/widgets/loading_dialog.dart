import 'package:flutter/material.dart';

showLoaderDialog(BuildContext context) {
  showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Center(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  // padding: EdgeInsets.all(20),
                  color: Colors.transparent,
                  child: const Center(
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator())))),
        );
      });
}