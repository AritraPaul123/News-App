import 'dart:convert';
import 'dart:developer';
import 'package:newsapp/NewsView.dart';

import 'home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model.dart';

class CategoryNews extends StatefulWidget {
  late String Query;
  CategoryNews(this.Query);
  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  bool isLoading=true;
  List<NewsQueryModel> newslist=<NewsQueryModel>[];

  getnewsquery(String query) async {
    dynamic url =
        "https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&apiKey=9f9536a024b349bca6eee96973de340d";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    var data = jsonDecode(response.body);
    data["articles"].forEach((element) {
      NewsQueryModel newsQueryModel = new NewsQueryModel();
      newsQueryModel = NewsQueryModel.fromMap(element);
      newslist.add(newsQueryModel);
      log(newslist.toString());
    });
    setState(() {
      isLoading = false;
    });
    newslist.forEach((element) {
      print(element.newshead);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getnewsquery(widget.Query);
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("NEWS APP"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.Query,style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            Container(
              child:  isLoading
                  ? Center(
                  heightFactor: 5,
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ))
                  :  ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: newslist.length,
                  itemBuilder: (context,index){
                    try{
                      return Container(
                      padding: EdgeInsets.symmetric(horizontal: 3,vertical: 3),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> NewsView(newslist[index].newsurl)));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 1.0,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child:
                                Image.network(newslist[index].newsimg.toString().endsWith("svg") ==true || (newslist[index].newsimg.toString())=="null" ? "https://www.gmt-sales.com/wp-content/uploads/2015/10/no-image-found.jpg" : newslist[index].newsimg,height: 230,fit: BoxFit.cover,width: double.infinity,),),
                              Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black12.withOpacity(0),
                                              Colors.black
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          )
                                      ),
                                      padding: EdgeInsets.fromLTRB(15, 30, 30, 2),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text((newslist[index].newshead.toString().length) > 85 ? "${newslist[index].newshead.toString().substring(0,85)}..." : newslist[index].newshead,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.white),),
                                          // Text(newslist[index].newsdesc ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),)
                                        ],
                                      ))
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                    }catch(e){
                      print(e);
                      return Container();
                    }

                  }),
            ),
          ],
        ),
      ),
    );
  }
}
