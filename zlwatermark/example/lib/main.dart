import 'package:flutter/material.dart';
import 'package:zlwatermark/zlwatermark.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: WaterPage(),
    );
  }
}

class WaterPage extends StatefulWidget {
  @override
  _WaterPageState createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  List<Widget> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("water"),
        actions: [
          IconButton(icon: Icon(Icons.image), onPressed: () {
            list.add(Image.asset("assets/gallery1.jpg", width: 100, height: 100, fit: BoxFit.cover,));
            setState(() {
            });
          }),
          IconButton(icon: Icon(Icons.add), onPressed: () {
            list.add(Text("aaaaaaaaaaaa", style: TextStyle(fontSize: 10, color: Colors.red),),);
            setState(() {
            });
          })
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ZLWaterView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/gallery3.jpg", fit: BoxFit.cover,)
              ),
              children: list,
            ),
          )
        ],
      ),
    );
  }
}
