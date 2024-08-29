import 'package:flutter/material.dart';
import 'package:notekeeper/add_update_task.dart';
import 'package:notekeeper/db_handler.dart';
import 'package:notekeeper/model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  @override
  void initState(){
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async{
    dataList = dbHelper!.getDataList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("DP-TODO",
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right:10),
            child:Icon(
              Icons.help_outline_rounded,
              size: 30,
            )
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: dataList,
             builder: (context,AsyncSnapshot<List<TodoModel>> snapshot){
              if(!snapshot.hasData || snapshot.data == null){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if(snapshot.data!.length == 0){
                return Center(
                  child: Text("No Task Found",style: TextStyle(
                    fontSize: 25,
                    fontWeight:FontWeight.bold,
                    color: Colors.white
                  ),),
                );
              }else{
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context,index){
                    int todoId = snapshot.data![index].id?.toInt() ?? 0;
                    String  todoTitle = snapshot.data![index].title.toString();
                    String tododesc = snapshot.data![index].desc.toString();
                    String todoDT = snapshot.data![index].dateandtime.toString();
                    return Dismissible(
                      key: ValueKey<int>(todoId),
                     direction: DismissDirection.endToStart,
                     background: Container(
                      color:Colors.redAccent,
                      child: Icon(Icons.delete_forever,color: Colors.white,),
                     ),
                     onDismissed: (DismissDirection direction) async{
                      await dbHelper!.delete(todoId);
                       setState(() {
                         dataList = dbHelper!.getDataList();
                         snapshot.data!.remove(snapshot.data![index]);
                       });
                     },
                     child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade300,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4, 
                            spreadRadius: 1,
                          )
                        ]
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title:Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(todoTitle,
                              style: TextStyle(fontSize: 19),
                              ),
                            ),
                            subtitle: Text(
                              tododesc,
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 0.8,
                          ),
                          Padding(padding:EdgeInsets.symmetric(
                            vertical: 3,horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  todoDT,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(
                                      context,MaterialPageRoute(
                                        builder: (context)=>AddUpdateTask(
                                          todoid:todoId,
                                          tododesc: tododesc,
                                          todotitle: todoTitle,
                                          todoDT: todoDT,
                                          Update : true,
                                        )
                                      )
                                    );
                                  },
                                  child: Icon(
                                    Icons.edit_note,
                                    size: 28,
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            ),
                            ),
                        ],
                      ),
                     ),
                    );
                  }
                );
              }
             }
            )
          ),
      ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add,
        ),
        onPressed: (){
          Navigator.push(
            context, MaterialPageRoute(
              builder: (context)=>AddUpdateTask(),
              )
              );
        }
      ),
    );
  }
}