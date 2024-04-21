class NewsQueryModel {
  dynamic newsimg;
  dynamic newsurl;
  dynamic newshead;
  dynamic newsdesc;

  NewsQueryModel({ this.newshead="NEWS HEADLINE", this.newsdesc="DESCRIPTION", this.newsimg="IMAGE", this.newsurl="URL"});

  factory NewsQueryModel.fromMap(Map news)
  {
    return NewsQueryModel(

        newshead: news["title"],
        newsdesc: news["author"],
        newsimg: news["urlToImage"],
        newsurl: news["url"]

    );
  }
}