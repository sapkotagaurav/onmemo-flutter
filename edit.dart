import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onmemo/Services/Posts.dart';

class EditPage extends StatefulWidget {
  final Posts posts;
  final DatabaseReference database;
  final String userid;

  EditPage(this.posts, this.database, this.userid);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController postController = TextEditingController();
  bool edit = true;
  bool updateDate = false;

  @override
  Widget build(BuildContext context) {
    var database = widget.database;
    titleController.text = widget.posts.title;
    postController.text = widget.posts.post;
    int date;
    if (widget.posts.Date == 1) {
      edit = false;
      date = DateTime
          .now()
          .millisecondsSinceEpoch;
    } else {
      edit = true;
      date = widget.posts.Date;
    }

    return Scaffold(
      appBar: new AppBar(
        title: Row(
          children: <Widget>[Icon(Icons.mode_edit), Text("Edit")],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Post",
                ),
                controller: postController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 5,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: checkBox(),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: MaterialButton(
                  child: Text("Save"),
                  onPressed: ()async {
                    String text = "";
                    if (validate(context)) {
                      if (edit) {
                        if (updateDate) {
                          Map<String, dynamic> map = Map();
                          map.putIfAbsent("title", () => titleController.text);
                          map.putIfAbsent("post", () => postController.text);
                          map.putIfAbsent("date", () => date);
                          database
                              .child("posts")
                              .child(widget.userid)
                              .child(widget.posts.key)
                              .update(map);
                          text = "Updated ${map["title"]}";
                       var lol = await   dialog(context, "Updated", text, Posts(
                              postController.text, titleController.text, date,
                              null));
                       Navigator.pop(context,lol);
                        } else {
                          Map<String, dynamic> map = Map();
                          map.putIfAbsent("title", () => titleController.text);
                          map.putIfAbsent("post", () => postController.text);
                          map.putIfAbsent("date",
                                  () =>
                              DateTime
                                  .now()
                                  .millisecondsSinceEpoch);
                          database
                              .child("posts")
                              .child(widget.userid)
                              .child(widget.posts.key)
                              .update(map);
                          text = "Updated ${map["title"]}";
                         var lol = await dialog(context, "Updated", text, Posts(
                              postController.text, titleController.text,
                              DateTime
                                  .now()
                                  .millisecondsSinceEpoch, null));
                          Navigator.pop(context,lol);
                        }

                        } else {
                        var key = database
                            .child("posts")
                            .child(widget.userid)
                            .key;
                        Map<String, dynamic> map = Map();
                        map.putIfAbsent("title", () => titleController.text);
                        map.putIfAbsent("post", () => postController.text);
                        map.putIfAbsent("date",
                                () =>
                            DateTime
                                .now()
                                .millisecondsSinceEpoch);
                        database.child("posts").child(widget.userid).push().set(
                            map);
                        text = "Updated ${map["title"]}";
                        Navigator.pop(
                            context,Posts(postController.text,titleController.text,DateTime.now().millisecondsSinceEpoch,key));
                      }

                    }
                  },
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget checkBox() {
    if (edit) {
      return CheckboxListTile(
        title: Text("Update Date"),
        value: updateDate,
        onChanged: (bool) {
          setState(() {
            updateDate = bool;
          });
        },
      );
    }
    return SizedBox(
      height: 1,
    );
  }

  bool validate(BuildContext context) {
    String error = "";
    if (titleController.text.isEmpty) {
      error += "Ttitle is Empty";
    }
    if (postController.text.isEmpty) {
      error += " Post is Empty";
    } else if (postController.text
        .split(" ")
        .length < 1) {
      error += "Post must contain atleast two words";
    }

    if (error.isEmpty) {
      return true;
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Row(
          children: <Widget>[Icon(Icons.error), Text(error)],
        ),
      ));
      return false;
    }
  }

  dialog(BuildContext context, String title, String content, Posts posts) async {
   await showDialog(context: context, child: AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        MaterialButton(child: Text("Ok"), onPressed: () {
          Navigator.of(context).pop(posts);
        },)

      ],
    ));
  }
}
