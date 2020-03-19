import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onmemo/Services/Posts.dart';
import 'package:onmemo/edit.dart';

class MainPage extends StatefulWidget {
  MainPage(this.post, this.uid, this.poss, this.posts);

  final String uid;
  final Posts post;
  final Future<List<Posts>> poss;
  final Future<List<Posts>> posts;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final database = FirebaseDatabase.instance.reference();
  final auth = FirebaseAuth.instance;
Posts posts;
String title;
String post;
int date1;
String date;
AppBar appBar;
  @override
  Widget build(BuildContext context) {
     posts = widget.post;
     title =posts.title;
     post = posts.post;
     date1 = posts.Date;
     date = DateTime.fromMillisecondsSinceEpoch(date1).toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      "Saved On: ${date.split(" ")[0].replaceAll("-", "/")} ${date.split(" ")[1].split(".")[0]}"
                          .toString(),
                      style: GoogleFonts.comfortaa(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      post,
                      style:
                          GoogleFonts.antic(textStyle: TextStyle(fontSize: 15)),
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      MaterialButton(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.mode_edit),
                            Text("Edit")
                          ],
                        ),
                        onPressed: () async {
                          Posts lol =  await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => EditPage(
                                      widget.post, database, widget.uid))));
                        Navigator.pop(context);


                        },
                      ),
                      MaterialButton(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.delete),
                            Text("Delete")
                          ],
                        ),
                        onPressed: () {
                          var uid = widget.uid;
                          database
                              .child("posts/$uid/${widget.post.key}")
                              .remove();
                          Navigator.pop(
                              context,
                              Row(
                                children: <Widget>[
                                  Icon(Icons.delete),
                                  Text("Deleted! ${widget.post.title}")
                                ],
                              ));
                        },
                      ),
                      MaterialButton(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.content_copy),
                            Text("Copy")
                          ],
                        ),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: widget.post.post));
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Row(
                              children: <Widget>[
                                Icon(Icons.content_copy),
                                Text("Copied!")
                              ],
                            ),
                          ));
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
