import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipeappflutter/RecipeModel.dart';
import 'package:recipeappflutter/views/recipe_view.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String applicationId = "ba4ce1ce";
  String applicationKey = "2753269fa6ab42f7532803de5550d0b2";


  TextEditingController textEditingController = new TextEditingController();

  List<RecipeModel> recipes = new List();

  getRecipes(String query) async {
    recipes.clear();
    String url = "https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey";
    var response = await http.get(url);
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["hits"].forEach((element){
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipes.add(recipeModel);
    });
  print(recipes.toString());

  setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    const Color(0xff312A50),
                    const Color(0xff071930)
                  ])
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: Platform.isIOS?60 :30, horizontal: 30) ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
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
                  SizedBox(height: 30,),
                  Text("What will you cook today", style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),),
                  SizedBox(height: 8,),
                  Text("just enter ingredients and we will show the recipe for you", style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),),
                  SizedBox(height: 30,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: "Enter ingredients",
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.5),
                              )
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 16,),
                        InkWell(
                          onTap: (){
                            if(textEditingController.text.isNotEmpty){
                              print(textEditingController.text);
                              getRecipes(textEditingController.text);
                            }
                            else{
                              print("just dont do it");
                            }
                          },
                          child: Container(
                            child: Icon(Icons.search, color: Colors.white,),
                          ) ,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    child: GridView(
                      shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200, mainAxisSpacing: 10.0
                        ),
                      children: List.generate(recipes.length, (index) {
                        return GridTile(
                            child: RecipeTile(
                              title: recipes[index].label,
                              desc: recipes[index].source,
                              imgUrl: recipes[index].image,
                              url: recipes[index].url,
                            ));
                      }),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RecipeTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipeTile({this.title, this.desc, this.imgUrl, this.url});


  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                        postUrl: widget.url,
                      )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'OverpassRegular'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
