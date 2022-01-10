import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_automation/flutter_automation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Scan barcode & QRcode'),
    );
  }
}

String txtData = 'Data';
String txtLine = 'Line';
String txtFaceBook = 'Facebook';
String txtYoutube = 'Youtube';
// String _name = 'Your Name';
String txtToChatMsg = '';
String? scanResult;
bool checkLineURL = false;
bool checkFacebookURL = false;
bool checkYoutubeURL = false;
bool checkData = false;

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    required this.text,
    required this.animationController,
    required this.txtLFBY,
    required this.color,
    Key? key,
  }) : super(key: key);
  final String? text;
  final AnimationController animationController;
  final String txtLFBY;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // final hl4 = Theme.of(context).textTheme.headline4;
    final textTheme = Theme.of(context).textTheme;

    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.ease),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: color,
                child: Text(
                  txtLFBY[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(txtLFBY, style: const TextStyle(fontSize: 20)),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    text!,
                    style: textTheme.bodyText2?.copyWith(
                      color: Colors.black54,
                      height: 1.5,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class ChatMessage extends StatefulWidget {
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

//   @override
//   _ChatMessageState createState() => _ChatMessageState();
// }

// class _ChatMessageState extends State<ChatMessage> {
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;

//     return SizeTransition(
//       sizeFactor: CurvedAnimation(
//           parent: widget.animationController, curve: Curves.ease),
//       axisAlignment: 0.0,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Container(
//             //   margin: const EdgeInsets.only(right: 16.0),
//             //   child: CircleAvatar(
//             //     backgroundColor: widget.color,
//             //     child: Text(
//             //       widget.txtLFBY[0],
//             //       style: const TextStyle(color: Colors.white),
//             //     ),
//             //   ),
//             // ),
//             ListTile(
//               title: Text(widget.txtLFBY, style: const TextStyle(fontSize: 20)),
//               subtitle: Text(
//                 widget.text!,
//                 style: textTheme.bodyText2?.copyWith(
//                   color: Colors.black54,
//                   height: 1.5,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             // Column(
//             //   crossAxisAlignment: CrossAxisAlignment.start,
//             //   children: [
//             //     Text(widget.txtLFBY, style: const TextStyle(fontSize: 20)),
//             //     Container(
//             //       margin: const EdgeInsets.only(top: 5.0),
//             //       child: Text(
//             //         widget.text!,
//             //         style: textTheme.bodyText2?.copyWith(
//             //           color: Colors.black54,
//             //           height: 1.5,
//             //           fontSize: 16,
//             //         ),
//             //       ),
//             //     ),
//             //   ],
//             // ),
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

  final List<ChatMessage> _messages = [];
  startScan() async {
    checkLineURL = false;
    checkFacebookURL = false;
    checkYoutubeURL = false;
    String? cameraScanResult = await scanner.scan();
    setState(() {
      scanResult = cameraScanResult;
      if (scanResult!.contains("line.me")) {
        checkLineURL = true;
        textLine();
        bgColor();
      } else if (scanResult!.contains("facebook.com")) {
        checkFacebookURL = true;
        textLine();
        bgColor();
      } else if (scanResult!.contains("youtube.com")) {
        checkYoutubeURL = true;
        textLine();
        bgColor();
      } else {
        checkData = true;
        textLine();
        bgColor();
      }
      _handleSubmitted(scanResult);
    });
  }

  textLine() {
    if (checkLineURL) {
      setState(() {
        txtToChatMsg = txtLine;
      });
      // return Text(txtLine, style: const TextStyle(fontSize: 20));
    } else if (checkFacebookURL) {
      setState(() {
        txtToChatMsg = txtFaceBook;
      });
      // return Text(txtFaceBook, style: const TextStyle(fontSize: 20));
    } else if (checkYoutubeURL) {
      setState(() {
        txtToChatMsg = txtYoutube;
      });
      // return Text(txtYoutube, style: const TextStyle(fontSize: 20));
    } else if (checkData) {
      setState(() {
        txtToChatMsg = txtData;
      });
      // return Text(txtData, style: const TextStyle(fontSize: 20));
    }
  }

  bgColor() {
    if (checkLineURL) {
      return Colors.lightGreenAccent[400];
    } else if (checkFacebookURL) {
      return Colors.blue[900];
    } else if (checkYoutubeURL) {
      return Colors.red;
    } else if (checkData) {
      return Colors.grey;
    }
  }

  void _handleSubmitted(String? text) {
    var message = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 900),
        vsync: this,
      ),
      txtLFBY: txtToChatMsg,
      color: bgColor(),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // checkYoutubeURL = true;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: false,
              itemBuilder: (_, index) {
                return Column(
                  children: [
                    ListTile(
                      title: _messages[index],
                      onTap: () async  {
                        if (_messages[index].txtLFBY == "Data") {
                          var snackBar = SnackBar(
                            content: Text('Barcode: ${_messages[index].text}'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {},
                            ),
                          );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          await launch(_messages[index].text.toString());
                        }
                      },
                    ),
                    const Divider(),
                  ],
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
      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: SizedBox(
      //       height: 300,
      //       width: double.infinity,
      //       child: Card(
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               const Text('ผลการสแกน', style: TextStyle(fontSize: 20)),
      //               const SizedBox(
      //                 height: 20,
      //               ),
      //               Text(scanResult ??= "No data",
      //                   style: const TextStyle(fontSize: 20)),
      //               const Spacer(),
      // checkLineURL
      //     ? SizedBox(
      //         width: double.infinity,
      //         child: ElevatedButton(
      //             onPressed: () async {
      //               if (await canLaunch(scanResult!)) {
      //                 //ถ้า link เป็น line ให้เปิด app line
      //                 await launch(scanResult!);
      //               }
      //             },
      //             child: const Text('ติดตามผ่าน Line'),
      //             style: ElevatedButton.styleFrom(
      //               primary: Colors.green[700],
      //               textStyle: const TextStyle(
      //                   fontSize: 20,
      //                   color: Colors.white,
      //                   fontWeight: FontWeight.bold),
      //             )),
      //       )
      //     : Container(),
      //               checkFacebookURL
      //                   ? SizedBox(
      //                       width: double.infinity,
      //                       child: ElevatedButton(
      //                           onPressed: () async {
      //                             if (await canLaunch(scanResult!)) {
      //                               await launch(scanResult!);
      //                             }
      //                           },
      //                           child: const Text('ติดตามผ่าน Facebook'),
      //                           style: ElevatedButton.styleFrom(
      //                             primary: Colors.blue[800],
      //                             textStyle: const TextStyle(
      //                                 fontSize: 20,
      //                                 color: Colors.white,
      //                                 fontWeight: FontWeight.bold),
      //                           )),
      //                     )
      //                   : Container(),
      //               checkYoutubeURL
      //                   ? SizedBox(
      //                       width: double.infinity,
      //                       child: ElevatedButton(
      //                           onPressed: () async {
      //                             if (await canLaunch(scanResult!)) {
      //                               await launch(scanResult!);
      //                             }
      //                           },
      //                           child: const Text('ติดตามผ่าน Youtube'),
      //                           style: ElevatedButton.styleFrom(
      //                             primary: Colors.red[600],
      //                             textStyle: const TextStyle(
      //                                 fontSize: 20,
      //                                 color: Colors.white,
      //                                 fontWeight: FontWeight.bold),
      //                           )),
      //                     )
      //                   : Container(),
      //             ],
      //           ),
      //         ),
      //       )),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: startScan,
        tooltip: 'Scan',
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
