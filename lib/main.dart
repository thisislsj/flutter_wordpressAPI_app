import 'package:flutter/material.dart';
import 'package:flutter_wordpressapi_app/post_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'post_page.dart';


void main(){
  runApp(MaterialApp(  
    home: WordPressHome()
  ));
}

class WordPressHome extends StatefulWidget{ 
  @override  
  State<StatefulWidget> createState() => WordPressHomeState();
}

class WordPressHomeState extends State<WordPressHome>{
  
  final String apiUrl="https://demo.wp-api.org/wp-json/wp/v2/";
  List posts;

  Future<String> getPosts() async{ 
    var res =await http.get(Uri.encodeFull(apiUrl+"posts?_embed"),headers:{"Accept": "application/json"});
    setState((){ 
      var resBody = json.decode(res.body);
      posts=resBody;
    });
    return "Success";
  }

  @override 
  void initState(){ 
    super.initState();
    this.getPosts();
  }

  @override 
  Widget build(BuildContext context){ 
    return Scaffold(  
      appBar: AppBar(  
        title: Text("WordPress Site"),
        backgroundColor: Colors.amberAccent,
      ),
      body: ListView.builder(  
        itemCount: posts==null ? 0 : posts.length,
        itemBuilder: (BuildContext context, int index){
          return Column (  
            children: <Widget>[ 
              Card(  
                child: Column(  
                  children: <Widget>[ 
                    new FadeInImage.memoryNetwork(  
                      placeholder: kTransparentImage,
                      image: posts[index]['featured_media']==0
                              ? '' 
                            : posts[index]["_embedded"]["wp:featuredmedia"][0]["source_url"]
                    ),                
                    new Padding(  
                      padding: EdgeInsets.all(10.0),
                      child: new ListTile(  
                        title: new Padding(  
                          padding: EdgeInsets.symmetric(vertical:10.0),
                          child: new Text(posts[index]["title"]["rendered"])),
                        subtitle: new Text(posts[index]["excerpt"]["rendered"].replaceAll(new RegExp(r'<[^>]*>'), ''),
                        ),
                      ),
                    ),
                    new ButtonTheme.bar(  
                      child:new ButtonBar(  
                        children: <Widget>[ 
                          new FlatButton(  
                            child: const Text('READ MORE'),
                            onPressed: (){ Navigator.push(  
                              context, new MaterialPageRoute(  
                                builder: (context) => new PostPage(post:posts[index]),
                              ),
                            );
                            }
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

  }
}