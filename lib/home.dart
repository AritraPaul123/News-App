import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/NewsView.dart';
import 'dart:convert';
import 'package:newsapp/model.dart';
import 'dart:developer';
import 'package:newsapp/category.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Map element;
  int i=0,j=0;
  late String query;
  late String country;
  bool isLoading = true;
  List<NewsQueryModel> newslist = <NewsQueryModel>[];
  List<NewsQueryModel> newsbycountrylist = <NewsQueryModel>[];
  TextEditingController searchcontroller = new TextEditingController();
  List<String> NavBarItem = [
    "Top News",
    "India",
    "Foreign",
    "Sports",
    "Health",
    "Politics"
  ];
  @override
  getnewsbycountry(String country) async {
    dynamic url =
        "https://newsapi.org/v2/top-headlines?country=$country&apiKey=9f9536a024b349bca6eee96973de340d";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    var data = jsonDecode(response.body);
    for(element in data["articles"]){
      try{
        i++;
        NewsQueryModel newsbycountryModel = new NewsQueryModel();
        newsbycountryModel = NewsQueryModel.fromMap(element);
        newsbycountrylist.add(newsbycountryModel);
        log(newsbycountrylist.toString());
        if(i==5)
          break;
      } catch(e){
        print(e);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  getnewsquery(String query) async {
    dynamic url =
        "https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&apiKey=9f9536a024b349bca6eee96973de340d";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    var data = jsonDecode(response.body);
    for(element in data["articles"]) {
      try{
        j++;
      NewsQueryModel newsQueryModel = new NewsQueryModel();
      newsQueryModel = NewsQueryModel.fromMap(element);
      newslist.add(newsQueryModel);
      log(newslist.toString());
      if(j==10)
        break;
      }catch(e){
        print(e);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getnewsquery("india");
    getnewsbycountry("in");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("This Is News App"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.black12,
              ),
              child: Row(children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: searchcontroller,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if ((value).replaceAll(" ", "") != "") {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoryNews(value)));
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search News",
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(24, 0, 0, 0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: GestureDetector(
                    onTap: () {
                      if ((searchcontroller.text).replaceAll(" ", "") != "") {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoryNews(searchcontroller.text)));
                      }
                    },
                    child: Container(
                      child: Icon(
                        Icons.search,
                        color: Colors.lightBlue[900],
                        size: 38,
                      ),
                      margin: EdgeInsets.fromLTRB(3, 7, 11, 7),
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: NavBarItem.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CategoryNews(NavBarItem[index])));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                            child: Text(
                          NavBarItem[index],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    );
                  }),
            ),
            Container(
              child: isLoading
                  ? Center(
                      heightFactor: 5,
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ))
                  : CarouselSlider(
                      items: newsbycountrylist.map(
                        (item) {
                          return Builder(builder: (BuildContext context) {
                            try{
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 8),
                                child
                                // ? Center(
                                //     child: CircularProgressIndicator(
                                //     strokeAlign: BorderSide.strokeAlignCenter,
                                //       color: Colors.black,
                                //   ))
                                    : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> NewsView(item.newsurl)));
                                    },
                                      child: Card(
                                                                        shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        elevation: 1.0,
                                                                        child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            item.newsimg
                                                .toString()
                                                .endsWith("svg") ==
                                                true ||
                                                (item.newsimg.toString()) ==
                                                    "null"
                                                ? "https://www.gmt-sales.com/wp-content/uploads/2015/10/no-image-found.jpg"
                                                : item.newsimg,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                        Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 15, 5, 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Colors.black12
                                                            .withOpacity(0),
                                                        Colors.black
                                                      ],
                                                      begin: Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter)),
                                              child: Text(
                                                (item.newshead
                                                    .toString()
                                                    .length) >
                                                    85
                                                    ? "${item.newshead.toString().substring(0, 85)}..."
                                                    : item.newshead,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 17),
                                              ),
                                            ))
                                      ],
                                                                        ),
                                                                      ),
                                    ));
                            }catch(e){
                              print(e);
                              return Container();
                            }

                          });
                        },
                      ).toList(),
                      options: CarouselOptions(
                        height: 250,
                        autoPlay: true,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                      )),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "LATEST NEWS",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
              child: isLoading
                  ? Center(
                      heightFactor: 5,
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: newslist.length,
                      itemBuilder: (context, index) {
                        try{
                          return Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 3, vertical: 3),
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
                                    child: Image.network(
                                      newslist[index]
                                          .newsimg
                                          .toString()
                                          .endsWith("svg") ==
                                          true ||
                                          (newslist[index]
                                              .newsimg
                                              .toString()) ==
                                              "null"
                                          ? "https://www.gmt-sales.com/wp-content/uploads/2015/10/no-image-found.jpg"
                                          : newslist[index].newsimg,
                                      height: 230,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              )),
                                          padding:
                                          EdgeInsets.fromLTRB(15, 20, 30, 5),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (newslist[index]
                                                    .newshead
                                                    .toString()
                                                    .length) >
                                                    85
                                                    ? "${newslist[index].newshead.toString().substring(0, 85)}..."
                                                    : newslist[index].newshead,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                              // Text(newslist[index].newsdesc ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),)
                                            ],
                                          )))
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryNews("India")));
                        },
                        child: Text(
                          "SEE MORE",
                          style: TextStyle(color: Colors.black),
                        )))
              ],
            )
          ],
        ),
      ),
    );
  }
}
