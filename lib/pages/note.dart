// enhanced ui
import 'package:database/data/local/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // controller
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  getNotes() async {
    allNotes = await dbRef!.getNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: allNotes.isNotEmpty
            ? ListView.builder(
                itemCount: allNotes.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          "?",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        allNotes[index][DBHelper.COL_NOTE_TITLE],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        allNotes[index][DBHelper.COL_NOTE_DESC],
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  titleController.text =
                                      allNotes[index][DBHelper.COL_NOTE_TITLE];
                                  descController.text =
                                      allNotes[index][DBHelper.COL_NOTE_DESC];
                                  return BottomSheetWidget(
                                      isUpdate: true,
                                      sno: allNotes[index]
                                          [DBHelper.COL_NOTE_SN]);
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              bool deleted = await dbRef!.deleteNotes(
                                  sno: allNotes[index][DBHelper.COL_NOTE_SN]);
                              if (deleted) {
                                getNotes();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  "No Notes Yet...",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return BottomSheetWidget();
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget BottomSheetWidget({bool isUpdate = false, int sno = 0}) {
    String errorMsg = "";
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isUpdate ? "Update Note" : "Add Note",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Title*',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description*',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.description),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: () async {
                  var title = titleController.text;
                  var desc = descController.text;

                  if (title.isNotEmpty && desc.isNotEmpty) {
                    bool chk = isUpdate
                        ? await dbRef!
                            .updateNotes(sno: sno, title: title, desc: desc)
                        : await dbRef!.addNote(mTitle: title, mDesc: desc);

                    if (chk) {
                      titleController.clear();
                      descController.clear();
                      getNotes();
                    }
                    Navigator.pop(context);
                  } else {
                    errorMsg = "Please fill all required fields.";
                    setState(() {});
                  }
                },
                child: Text(isUpdate ? "Update" : "Add"),
              ),
              OutlinedButton(
                onPressed: () {
                  titleController.clear();
                  descController.clear();
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
          if (errorMsg.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorMsg,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}

// import 'package:database/data/local/db_helper.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // controller
//   TextEditingController titleController = TextEditingController();
//   TextEditingController descController = TextEditingController();

//   List<Map<String, dynamic>> allNotes = [];
//   DBHelper? dbRef;

//   @override
//   void initState() {
//     super.initState();
//     dbRef = DBHelper.getInstance;
//     getNotes();
//   }

//   getNotes() async {
//     allNotes = await dbRef!.getNotes();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Notes"),
//       ),
//       body: allNotes.isNotEmpty
//           ? ListView.builder(
//               itemCount: allNotes.length,
//               itemBuilder: (context, index) {
//                 //list all notes
//                 return ListTile(
//                     leading: Text("${allNotes[index][DBHelper.COL_NOTE_SN]}",
//                         style: const TextStyle(color: Colors.blue)),
//                     title: Text(
//                       allNotes[index][DBHelper.COL_NOTE_TITLE],
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                     subtitle: Text(allNotes[index][DBHelper.COL_NOTE_DESC],
//                         style: const TextStyle(color: Colors.green)),
//                     trailing: SizedBox(
//                       width: 50,
//                       child: Row(
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               showModalBottomSheet(
//                                   context: context,
//                                   builder: (context) {
//                                     titleController.text = allNotes[index]
//                                         [DBHelper.COL_NOTE_TITLE];
//                                     descController.text =
//                                         allNotes[index][DBHelper.COL_NOTE_DESC];
//                                     return BottomSheetWidget(
//                                         isUpdate: true,
//                                         sno: allNotes[index]
//                                             [DBHelper.COL_NOTE_SN]);
//                                   });
//                             },
//                             child: Icon(Icons.edit),
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               bool deleted = await dbRef!.deleteNotes(
//                                   sno: allNotes[index][DBHelper.COL_NOTE_SN]);
//                               if (deleted) {
//                                 getNotes();
//                               }
//                             },
//                             child: Icon(
//                               Icons.delete,
//                               color: Colors.red,
//                             ),
//                           )
//                         ],
//                       ),
//                     ));
//               })
//           : const Center(
//               child: Text("No Notes Yet...."),
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // note to  be add
//           showModalBottomSheet(
//               context: context,
//               builder: (contex) {
//                 return BottomSheetWidget();
//               });
//         },
//         child: const Icon(Icons.add, color: Colors.green),
//       ),
//     );
//   }

//   // Widget

//   Widget BottomSheetWidget({bool isUpdate = false, int sno = 0}) {
//     String errorMsg = "";
//     return Container(
//       padding: const EdgeInsets.all(11),
//       width: double.infinity,
//       child: Column(
//         children: [
//           const Text(
//             "Add Notes..",
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(
//             height: 21,
//           ),
//           TextField(
//               controller: titleController,
//               decoration: InputDecoration(
//                 hintText: "Enter title here...",
//                 label: Text('title*'),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(11))),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(11))),
//               )),
//           const SizedBox(
//             height: 8,
//           ),
//           TextField(
//               controller: descController,
//               decoration: InputDecoration(
//                 hintText: "Enter description here...",
//                 label: Text('desc*'),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(11))),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(11))),
//               )),
//           SizedBox(
//             height: 11,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               OutlinedButton(
//                   onPressed: () async {
//                     var title = titleController.text;
//                     var desc = descController.text;

//                     if (title.isNotEmpty && desc.isNotEmpty) {
//                       bool chk = isUpdate
//                           ? await dbRef!
//                               .updateNotes(sno: sno, title: title, desc: desc)
//                           : await dbRef!.addNote(mTitle: title, mDesc: desc);

//                       if (chk) {
//                         titleController.clear();
//                         descController.clear();
//                         getNotes();
//                       }
//                       Navigator.pop(context);
//                     } else {
//                       errorMsg = "Please Field All required Fields..";
//                       setState(() {});
//                     }
//                   },
//                   child: Text(isUpdate ? "Update Note" : "Add Note")),
//               OutlinedButton(
//                   onPressed: () {
//                     titleController.clear();
//                     descController.clear();
//                     Navigator.pop(context);
//                   },
//                   child: Text("Cancel")),
//               Text('$errorMsg'),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
