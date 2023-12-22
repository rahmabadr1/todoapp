import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/archived_tasks.dart';
import 'package:todoapp/modules/done_tasks.dart';
import 'package:todoapp/modules/tasks.dart';
import 'package:todoapp/shared/compontes/compontes.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   int currentindex=0;
   List<Widget> Screens=[
     Tasks(),Done(),Archived(),];
   List<String> Titels=[
     "Tasks",
     "Done Tasks",
     "Archived Taks",];
   late Database database;
    var scafoldKey=GlobalKey<ScaffoldState>();
    var formKey =GlobalKey<FormState>();
    bool isShowen= false;
   IconData flotIcon=Icons.edit;
    var  titleController= TextEditingController();
    var dateController=  TextEditingController() ;
    var timeController= TextEditingController() ;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDatabase();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white70,
        title: Container(alignment: AlignmentDirectional.center,
            child: Text(Titels[currentindex],style: TextStyle(color: Colors.deepOrange,fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
        ),
      ),
      body:
      Screens[currentindex],
      key: scafoldKey
      ,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentindex,
        onTap: (index){
          setState(() {
           currentindex=index;
          });
      },
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.menu,color: Colors.deepOrange,),label: 'Tasks',),
        BottomNavigationBarItem(icon: Icon(Icons.check_box_outlined,color: Colors.deepOrange,),label: 'Done'),
        BottomNavigationBarItem(icon: Icon(Icons.archive_outlined,color: Colors.deepOrange,),label: 'Archived'),
      ],),
      floatingActionButton:FloatingActionButton(onPressed: (){
        if(isShowen){
          if(formKey.currentState!.validate()){
             insertToDatabase(title: titleController.text,date: dateController.text,time: timeController.text).then((value) {
              Navigator.pop(context);
              isShowen=false;
              setState(() {
                flotIcon=Icons.edit;
              });
            }
            );
        }
      } else {
          isShowen=true;
          setState(() {
            flotIcon=Icons.add;
          });

          scafoldKey.currentState!.showBottomSheet((context) =>
              SingleChildScrollView(
                child: Expanded(
                  child: Container(width: double.infinity,
                    color: Colors.deepOrange[200],
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                         defaultTextForm(fieldcontroler: titleController,
                             prefixicon: Icon(Icons.title),
                             textInput: TextInputType.text,
                             Text: 'Title',
                             validator: ( value){
                             if (value!.isEmpty){
                               return ('enter title please');
                             }else{
                               return null;
                             }
                             }
                         ),
                          SizedBox(height: 10,),

                          defaultTextForm(
                              fieldcontroler: dateController,
                              onTTapp: (){
                               showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.parse('2023-12-15'),)
                                   .then((value) =>   dateController.text=DateFormat.yMMMd().format(value!).toString());
                              },
                              prefixicon: Icon(Icons.date_range),
                              textInput: TextInputType.text,
                              Text: "Date",
                              validator: ( value){
                                if (value!.isEmpty){
                                  return ('enter date please');
                                }else{
                                  return null;
                                }
                              }
                          ),
                          SizedBox(height: 10,),
                          defaultTextForm(
                               onTTapp: (){
                                 showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) => timeController.text=value!.format(context).toString());
                               },
                              fieldcontroler: timeController,
                              prefixicon: Icon(Icons.watch_later_outlined),
                              textInput: TextInputType.text,
                              Text: "Time",
                              validator: (value){
                            if (value.isNull){
                              return ('enter time please');
                            }else{
                              return null;
                            }
                          }),

                        ],
                      ),
                    ),),
                ),
              )).closed.then((value) {
                isShowen=false;
                setState(() {
                  flotIcon=Icons.edit;
                });
          });
        }
        },child: Icon(flotIcon),backgroundColor: Colors.deepOrange,) ,
    );
  }
  Future<void> createDatabase() async {
    database= await openDatabase('Todo.db',
       version: 1,
       onCreate: (database,version)async
       {
     print("database created");
    await  database.execute("CREATE TABLE TASKS(ID INTEGER PRIMARY KEY ,TITLE TEXT,DATE TEXT,TIME TEXT,STATUS TEXT )").then((value) => print ("table created"))
        .catchError((error){
       print("Error ocreaed on created table ${error.toString()}");
     });
   },
     onOpen: (database){
       print("database opened");
     },


   );
  }
     Future <void> insertToDatabase({required String title,required String date,required String time}) async{
     await database.transaction((txn)
     => txn.rawInsert( 'INSERT INTO TASKS (TITLE,DATE,TIME,STATUS) VALUES ("$title","$date","$time","NEW")').then((value) {
        print('Title = $title,Date =$date,Time=$time');
        print("$value inserted to database");
      }).catchError((error){
        print("error occured on insert to database${error.toString()}");
      }));








     }



}
