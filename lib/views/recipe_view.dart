import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {

  final String postUrl;
  RecipeView({@required this.postUrl});


  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {

  String finalUrl;

  final Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  void initState() {
    if(widget.postUrl.contains('http')){
      finalUrl=widget.postUrl.replaceAll("http", "https");
    }
    else{
      finalUrl=widget.postUrl;
    }
    print("final url is $finalUrl");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        const Color(0xff312A50),
                        const Color(0xff071930)
                      ])
              ),
              padding: EdgeInsets.only(
                  top: Platform.isIOS?60 :60, left: 30, right: 30, bottom: 15) ,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: kIsWeb? MainAxisAlignment.start : MainAxisAlignment.center,
                children: <Widget>[
                  Text("APPGuy", style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),),
                  Text("Recipes", style: TextStyle(
                      color: Colors.blue, fontSize: 18
                  ),)
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height-100,
              width: MediaQuery.of(context).size.width,
              child: WebView(
                initialUrl: finalUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController){
                  setState(() {
                    _controller.complete(webViewController);
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
