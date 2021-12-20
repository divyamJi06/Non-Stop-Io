import 'package:flutter/material.dart';
import 'package:tinderly/view/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CardPage()
        // Scaffold(
        //   body: Center(
        //     child: Column(
        //       children: [
        //         OutlinedButton(
        //             onPressed: () {
        //               Navigator.push(context,
        //                   MaterialPageRoute(builder: (context) => CardPage()));
        //             },
        //             child: Text("Login"))
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
