import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/api/todo_controller.dart';

class TodoPage extends StatefulWidget {
  TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // _sendingMails() async {
  //   var url = Uri.parse("mailto:feedback@geeksforgeeks.org");
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  void sendEmail(BuildContext context, String subject, String body) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: '', // add recipient email here if needed
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      // Handle unable to launch email client
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unable to launch email client'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    TextEditingController editController = TextEditingController();
    TodoController todoCntrl = Get.put(TodoController());
    bool isEdited = false;
    void MyBottomSheet() {
      Get.bottomSheet(Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(color: Colors.white),
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(hintText: "Enter a task"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    textController.clear();
                  },
                  child: Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () {
                    todoCntrl.postData(textController.text.toString());
                    Get.back();
                    textController.clear();
                  },
                  child: Text("SAVE"),
                ),
              ],
            ),
          ],
        ),
      ));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "T O D O",
              style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ),
            // Container(
            //   padding: EdgeInsets.all(10),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     color: Colors.blue,
            //   ),
            //   child: Icon(
            //     Icons.add,
            //     size: 35,
            //   ),
            // ),
            SizedBox(
              height: 550,
              child: SingleChildScrollView(
                child: Obx(
                  () => todoCntrl.isLoaded.value
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: todoCntrl.todoList
                              .map(
                                (e) => InkWell(
                                  onTap: () {
                                    MyBottomSheet();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    decoration:
                                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              text: e.title.toString(),
                                              style: TextStyle(
                                                  color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Center(
                                                    child: IconButton(
                                                  onPressed: () {
                                                    editController.text = e.title
                                                        .toString(); // Populate the dialog with the current title
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Edit Task'),
                                                          content: TextFormField(
                                                            controller: editController,
                                                            decoration: InputDecoration(hintText: 'Enter new title'),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child: Text('CANCEL'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                todoCntrl.putData(e.id, editController.text);
                                                                Get.back();
                                                              },
                                                              child: Text('SAVE'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },

                                                  // onPressed: () {
                                                  //   todoCntrl.putData(e.id, e.title.toString());
                                                  // },
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  // _sendingMails();
                                                  sendEmail(
                                                    context,
                                                    'Regarding tasksharing',
                                                    e.title.toString(),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.share,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Center(
                                                    child: IconButton(
                                                  onPressed: () {
                                                    todoCntrl.deleteData(e.id);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
