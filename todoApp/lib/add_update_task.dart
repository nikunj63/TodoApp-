import 'package:flutter/material.dart';
import 'package:notekeeper/db_handler.dart';
import 'package:notekeeper/home_screen.dart';
import 'package:notekeeper/model.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AddUpdateTask extends StatefulWidget {

  int? todoid;
  String? todotitle;
  String? tododesc;
  String? todoDT;
  bool? Update;


   AddUpdateTask({
    super.key,
    this.todoid,
    this.todotitle,
    this.tododesc,
    this.Update,
    this.todoDT,

    
    });

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {

  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }
  loadData()async{
    dataList = dbHelper!.getDataList();
  }


  @override
  Widget build(BuildContext context) {
    final titlecontroller = TextEditingController(text:widget. todotitle);
    final desccontroller = TextEditingController(text: widget.tododesc);
    String appTitle;
    if (widget.Update==true) {
      appTitle= "Update Task";
    }else{
      appTitle = "Add task";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          child: Column(children: [
            Form(
              key: _formKey,
              child:Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: titlecontroller ,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Note Title",
                      ),
                      validator: (value){
                        if (value!.isEmpty) {
                          return 'Enter Some Text';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 5,
                      controller: desccontroller ,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Write notes here",
                      ),
                      validator: (value){
                        if (value!.isEmpty) {
                          return "Enter Some Text";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              )
             ),
             SizedBox(height: 40,),
             Container(
              width:MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap:(){
                        if (_formKey.currentState!.validate()) {
                          if (widget.Update ==true){
                            dbHelper!.update(TodoModel(
                              id: widget.todoid,
                            title:titlecontroller.text,
                            desc: desccontroller.text,
                            dateandtime: widget.todoDT,
                            

                          ));

                          }else{
                            dbHelper!.insert(TodoModel(
                            title:titlecontroller.text,
                            desc: desccontroller.text,
                            dateandtime: DateFormat('yMd')
                            .add_jm()
                            .format(DateTime.now())
                            .toString()

                          ));

                          }

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context)=>HomeScreen()
                          ));
                          titlecontroller.clear();
                          desccontroller.clear();
                          print("Data added");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height:50,
                        width:120,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 1,
                            )
                          ]
                        ),
                        child: Text("Submit",
                        style:TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ) ,
                        ),
                      ),
                    ),
                  ),
                   Material(
                    color: Colors.red.shade300,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap:(){
                        setState(() {
                          titlecontroller.clear();
                          desccontroller.clear();
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height:50,
                        width:120,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 1,
                            )
                          ]
                        ),
                        child: Text("Clear",
                        style:TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ) ,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
             )
          ],),
        ),
      ),
    );
  }
}