import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onmemo/Services/auth.dart';
import 'package:onmemo/edit.dart';
import 'package:onmemo/mainpage.dart';

import 'Services/Posts.dart';

class HomePage extends StatefulWidget {
  HomePage(this.user, this.userid, this.logoutcallback);

  BaseAuth auth;
  VoidCallback logoutcallback;
  String userid;
  final FirebaseUser user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Posts>> poss;

  Future<List<Posts>> posts() async {
    var databaseref = FirebaseDatabase.instance.reference();
    List<Posts> post = [];
    DataSnapshot s = await databaseref
        .child("posts/${widget.userid}")
        .once()
        .whenComplete(() => null);
    Map<dynamic, dynamic> user = s.value;
    user.forEach((key, value) {
      post.add(Posts(value['post'], value['title'], value['date'], key));
    });
    return post;
  }

  @override
  initState() {
    super.initState();
    poss = posts();
  }

  @override
  Widget build(BuildContext context) {
    var databaseref = FirebaseDatabase.instance
        .reference()
        .child("posts")
        .child(widget.userid);
    var database= FirebaseDatabase.instance
        .reference();
    FirebaseUser user = widget.user;
    /*databaseref.onChildAdded.listen((event) {
      setState(() {
        poss = posts();
      });
    });
    databaseref.onChildChanged.listen((event) {
      setState(() {
        poss = posts();
      });
    });*/
    databaseref.onValue.listen((event) {
      setState(() {
        poss = posts();
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(user.displayName.split(" ")[0] + "'s Memos"),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              setState(() {
                widget.logoutcallback();
              });
            },
            child: Text("Log Out"),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: fututeb(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
         var lol = await Navigator.push(context, MaterialPageRoute(builder: (context)=>EditPage(Posts("","",1,""),database,widget.userid)));
         if(lol!=null) {
print(lol.title)     ;
    }
        },
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Container work(String d) {
    return Container(
      child: Center(
        child: Text(d),
      ),
    );
  }

  Widget lol(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.data != null) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(snapshot.data[index].title),
                leading: ImageIcon(AssetImage("assets/profile.png")),
                trailing: MaterialButton(
                  child: Icon(Icons.delete),
                  onPressed: () {
                    delete(snapshot.data[index]);
                  },
                ),
                subtitle: Text(
                  snapshot.data[index].post,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () async {
                  var lol = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainPage(snapshot.data[index],
                              widget.userid, poss, posts())));
                  setState(() {
                    poss = posts();
                  });
                  if (lol != null) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: lol,
                    ));
                  }
                },
              );
            }),
      );
    } else {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Widget fututeb() {
    FutureBuilder futureBuilder = FutureBuilder(
      future: poss,
      builder: lol,
    );
    return futureBuilder;
  }

  delete(Posts ps) {
    FirebaseDatabase.instance
        .reference()
        .child("posts/${widget.userid}/${ps.key}")
        .remove();
  }
}
