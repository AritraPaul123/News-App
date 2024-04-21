

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsView extends StatefulWidget {
  late String url;
  NewsView(this.url);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  late String finalurl;

  @override
  void initState() {
    if(widget.url.toString().contains("http://")){
      finalurl=widget.url.toString().replaceAll("http://", "https://");
    }
    else{
      finalurl=widget.url;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("News View Page"),
        ),
        body: Container(
            child: WebViewWidget(controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(Uri.parse(finalurl)),
            )
        )

    );
  }
}
