import 'package:flutter/material.dart';
import 'package:flutter_scanner/widget/card_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_automation/flutter_automation.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Scan barcode & QRcode'),
    );
  }
}


// String _name = 'Your Name';
String txtToChatMsg = '';
String? scanResult;
bool checkLineURL = false;
bool checkFacebookURL = false;
bool checkYoutubeURL = false;
bool checkData = false;

// class ChatMessage extends StatelessWidget {
//   const ChatMessage({
//     required this.text,
//     required this.animationController,
//     required this.txtLFBY,
//     required this.color,
//     Key? key,
//   }) : super(key: key);
//   final String? text;
//   final AnimationController animationController;
//   final String txtLFBY;
//   final Color color;
//
//   @override
//   Widget build(BuildContext context) {
//     // final hl4 = Theme.of(context).textTheme.headline4;
//     final textTheme = Theme.of(context).textTheme;
//
//     return SizeTransition(
//       sizeFactor:
//           CurvedAnimation(parent: animationController, curve: Curves.ease),
//       axisAlignment: 0.0,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: const EdgeInsets.only(right: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: color,
//                     child: Text(
//                       txtLFBY[0],
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(txtLFBY, style: const TextStyle(fontSize: 20)),
//                   Container(
//                     margin: const EdgeInsets.only(top: 5.0),
//                     child: Text(
//                       text!,
//                       style: textTheme.bodyText2?.copyWith(
//                         color: Colors.black54,
//                         height: 1.5,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // ignore: prefer_typing_uninitialized_variables
  // final db = sqlite3.openInMemory();

  final List<CardWidget> _messages = [];

  @override
  void initState() {
    bind();
    super.initState();
  }

  bind() async {
    var databasesPath = await getDatabasesPath();
    print("databaseeeeee: ${databasesPath}");
    String path = Join(databasesPath, 'demo.db');
  }


  @override
  Widget build(BuildContext context) {

    // checkYoutubeURL = true;
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.indigoAccent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: false,
              itemBuilder: (_, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: _messages[index],
                        onTap: () async {
                          if (_messages[index].title == txtData) {
                            var snackBar = SnackBar(
                              content:
                                  Text('Barcode: ${_messages[index].text}'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {},
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            await launch(_messages[index].text.toString());
                          }
                        },
                      ),
                    ],
                  ),
                );
                // return GestureDetector(
                //   child: _messages[index],
                //   onTap: () async {
                //     if (_messages[index].txtLFBY == "Data") {
                //       final snackBar = SnackBar(
                //         content: Text('Barcode: ${_messages[index].text}'),
                //         action: SnackBarAction(
                //           label: 'Undo',
                //           onPressed: () {},
                //         ),
                //       );
                //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //     } else {
                //       await launch(_messages[index].text.toString());
                //     }
                //   },
                // );
              },
              itemCount: _messages.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startScan,
        tooltip: 'Scan',
        child: const Icon(Icons.qr_code_scanner),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }

  startScan() async {
    checkLineURL = false;
    checkFacebookURL = false;
    checkYoutubeURL = false;
    String? scanResult;
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
    ].request();
    if((statuses[Permission.storage]?.isGranted ?? false) && (statuses[Permission.camera]?.isGranted??false)){
      scanResult = await scanner.scan();
      analyze(scanResult??"No data");
    }else {
      if (statuses[Permission.storage]!.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("การเข้าถึงข้อมูลถูกปฏิเสธ"),
        ));
      }

      if (statuses[Permission.camera]!.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("การเข้าถึงกล้องถูกปฏิเสธ"),
        ));
      }
    }


      // setState(() {
      // scanResult = cameraScanResult;
      // if (scanResult!.contains("line.me")) {
      //   checkLineURL = true;
      //   textLine();
      //   bgColor();
      // } else if (scanResult!.contains("facebook.com")) {
      //   checkFacebookURL = true;
      //   textLine();
      //   bgColor();
      // } else if (scanResult!.contains("youtube.com")) {
      //   checkYoutubeURL = true;
      //   textLine();
      //   bgColor();
      // } else {
      //   checkData = true;
      //   textLine();
      //   bgColor();
      // }
      // _handleSubmitted(scanResult);
    // });
  }
  String txtData = 'Data';
  // String txtLine = 'Line';
  // String txtFaceBook = 'Facebook';
  // String txtYoutube = 'Youtube';
  List<String> text =['Data','Line','Facebook','Youtube'];
  Color? colorLine = Colors.lightGreenAccent[400];
  Color? colorFB = Colors.blue[900];
  Color? colorYT = Colors.red;
  Color? colorData = Colors.grey;
  analyze(String data){
    if(data.contains("line.me")){
      _handleSubmitted(data,text[1],colorLine);
    }else if(data.contains("facebook.com")){
      _handleSubmitted(data,text[2],colorFB);
    }else if(data.contains("youtube.com")){
      _handleSubmitted(data,text[3],colorYT);
    }else{
      _handleSubmitted(data,text[0],colorData);
    }
  }

  // textLine() {
  //   if (checkLineURL) {
  //     setState(() {
  //       txtToChatMsg = txtLine;
  //     });
  //     // return Text(txtLine, style: const TextStyle(fontSize: 20));
  //   } else if (checkFacebookURL) {
  //     setState(() {
  //       txtToChatMsg = txtFaceBook;
  //     });
  //     // return Text(txtFaceBook, style: const TextStyle(fontSize: 20));
  //   } else if (checkYoutubeURL) {
  //     setState(() {
  //       txtToChatMsg = txtYoutube;
  //     });
  //     // return Text(txtYoutube, style: const TextStyle(fontSize: 20));
  //   } else if (checkData) {
  //     setState(() {
  //       txtToChatMsg = txtData;
  //     });
  //     // return Text(txtData, style: const TextStyle(fontSize: 20));
  //   }
  // }
  //
  // bgColor() {
  //   if (checkLineURL) {
  //     return Colors.lightGreenAccent[400];
  //   } else if (checkFacebookURL) {
  //     return Colors.blue[900];
  //   } else if (checkYoutubeURL) {
  //     return Colors.red;
  //   } else if (checkData) {
  //     return Colors.grey;
  //   }
  // }

  void _handleSubmitted(String data, String title,Color? color) {
    var message = CardWidget(
      text: data,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 900),
        vsync: this,
      ),
      title: title,
      color: color,
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }
}
