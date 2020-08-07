import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class todoUi extends StatefulWidget {
  @override
  _todoUiState createState() => _todoUiState();
}

class _todoUiState extends State<todoUi> {
  // List todos = List();
  String input = "";
  
  createTodos() {
    DocumentReference documentReference =
        Firestore.instance.collection("MyTodos").document(input);
    //Maping
    Map<String, String> todos = {"todosTitle": input};
    documentReference.setData(todos).whenComplete(() {
      print("$input created");
    });
  }

  deleteTodos(item) {
    
    DocumentReference documentReference =
   Firestore.instance.collection("MyTodos").document(item);
    //Maping
    documentReference.delete().whenComplete(() {
      print("$item deleted");
  });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sharjeel's TODO LIST"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text("Add Your Task"),
                  content: TextField(
                    onChanged: (String value) {
                      input = value;
                    },
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          createTodos();
                          Navigator.of(context).pop();
                        },
                        child: Text("Add"))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("MyTodos").snapshots(),
          builder: (context, snapshots) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshots.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                  snapshots.data.documents[index];
                  return Dismissible(
                    onDismissed: (direction){
                      deleteTodos(
                        documentSnapshot["todosTitle"]
                      );
                    },
                    key: Key(index.toString()),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                           title: Text(
                             documentSnapshot["todosTitle"]
                           ),
                          trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                deleteTodos(documentSnapshot["todosTitle"]);
                              })),
                    ),
                  );
                });
          }),
    );
  }
}
