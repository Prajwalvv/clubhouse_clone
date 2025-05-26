import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubhouse/models/userModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clubhouse/widgets/getTheTitle.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:date_time_picker/date_time_picker.dart';

class CreateAClub extends StatefulWidget {
  final UserModel? user;
  final GetTheTitle? title;
  //final String? callItem;
  final List<Map<String, dynamic>>? items;
  CreateAClub({this.user, this.title, this.items});
  @override
  _CreateAClubState createState() => _CreateAClubState();
}

class _CreateAClubState extends State<CreateAClub> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _speakerController = TextEditingController();
  List<String> categories = [];
  List<Map> speakers = [];
  String? selectedCategory = "";
  DateTime? _dateTime;
  String type = "Private";


  //Map<String, String> getit = widget.title.titleName;

  // Future FetchCategories() async {
  //   DocumentSnapshot variable = await FirebaseFirestore.instance
  //       .collection("categories")
  //       .doc("GbUxfI8OPULV0iOEYg7K")
  //       .get();
  //   callItem = variable["title1"];
  //   setState(() {
  //   });
  // }

  @override
  void initState() {
    FetchCategorie();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();

    super.dispose();
  }

  Future FetchCategorie() async {
    FirebaseFirestore.instance.collection('categories').get().then((value) {
      value.docs.forEach((element) {
        categories.add(element.data()["title"]);
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1efe5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Create your club",style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == "") {
                      return "Field is required";
                    }
                    return null;
                  },
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Discussion Topic",
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItem: true,
                  items: categories,
                  label: "Categorie",
                  hint: "Select a categorie",
                  //popupItemDisabled: (String s) => s.startsWith('I'),
                  onChanged: (value) {
                    selectedCategory = value;
                  },
                  //selectedItem: "Brazil",
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: _speakerController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Invite Speakers(optional)",
                          helperText: "eg: +918790****5"),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("users")
                              .where("phone",
                                  isEqualTo: _speakerController.text)
                              .get()
                              .then((value) {
                            if (value.docs.length > 0) {
                              speakers.add({
                                "name": value.docs.first.data()["name"],
                                "phone": _speakerController.text,
                              });
                              _speakerController.text = "";
                              setState(() {});
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text(
                                  "No User Found",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ));
                            }
                          });
                        },
                        child: Text("Add"))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ...speakers.map((user) {
                  var name = user.values.first;
                  var phone = user.values.last;
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text(name),
                    subtitle: Text(phone),
                  );
                }),
                Text(
                  "Select Date Time Below",
                  style: TextStyle(),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 180,
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    mode: CupertinoDatePickerMode.dateAndTime,
                    onDateTimeChanged: (DateTime dateTime){
                      _dateTime = dateTime;
                    },
                  ),
                ),

                SizedBox(height: 15,),
                Row(
                  children: [
                    Text("Discussion Type"),
                    Radio(value: "Private", groupValue: type, onChanged: (value){
                      setState(() {
                        type = value.toString();
                      });
                    }),
                    Text("Private", style: TextStyle(fontSize: 16),),
                    Radio(value: "Public", groupValue: type, onChanged: (value){
                      setState(() {
                        type = value.toString();
                      });
                    }),
                    Text("Public", style: TextStyle(fontSize: 16),),
                  ],
                ),

                SizedBox(height: 40,),

                Row(
                  children: [
                    Expanded(child: ElevatedButton(onPressed: ()async{
                      if(selectedCategory == ""){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.redAccent, content: Text("Select a category", style: TextStyle(color: Colors.white),),),);
                        return;
                      }
                      if(_formKey.currentState!.validate()){
                        _formKey.currentState?.save();
                        speakers.insert(0,{
                          "name": widget.user?.name,
                          "phone": widget.user?.phone,
                        });

                        await FirebaseFirestore.instance.collection("clubs").add({
                          "title": _titleController.text,
                          "category": selectedCategory,
                          "createdBy": widget.user?.phone,
                          "invited":speakers,
                          "createdOn": DateTime.now(),
                          "dateTime":_dateTime,
                          "type": type,
                          "status": "new"
                        });
                        Navigator.pop(context);
                      }
                    }, child: Text("Create"))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
