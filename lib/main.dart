import 'dart:ffi';

import 'package:dragpicturepuzzel/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) => runApp(MyApp()));
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
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DragPicture(),
    );
  }
}

class DragPicture extends StatefulWidget {
  @override
  _DragPictureState createState() => _DragPictureState();
}

class _DragPictureState extends State<DragPicture> {
  List<bool> _isDone = [false, false, false];
  List<bool> elementState = [false, false, false];
  double itemsize = 70;
  double newsize = 70;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 500,
                height: 180,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/board3.png"))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: itemlist
                          .map((item) => Padding(
                                padding: const EdgeInsets.all(20),
                                child: DragTarget<Itemdata>(
                                  onWillAccept: (data) =>
                                      data.name == item.name,
                                  onAccept: (e) {
                                    setState(() {
                                      _isDone[itemlist.indexOf(e)] = true;
                                      elementState[itemlist.indexOf(e)] = true;
                                    });
                                  },
                                  builder: (BuildContext context, List incoming,
                                      List rejected) {
                                    return _isDone[itemlist.indexOf(item)]
                                        ? Container(
                                            height: newsize,
                                            width: newsize,
                                            child:
                                                SvgPicture.asset(item.address),
                                          )
                                        : Container(
                                            height: itemsize,
                                            width: itemsize,
                                            child: SvgPicture.asset(
                                              item.address,
                                              color: Colors.black45,
                                            ),
                                          );
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 500,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.black87.withOpacity(0.7),
                      border: Border.all(
                          color: Colors.black54.withOpacity(0.8), width: 3)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Wrap(
                        children: itemlist
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Draggable<Itemdata>(
                                    data: e,
                                    onDragStarted: () {
                                      setState(() {
                                        newsize = 80;
                                      });
                                    },
                                    childWhenDragging: Container(
                                      height: itemsize,
                                      width: itemsize,
                                    ),
                                    feedback: Container(
                                      height: itemsize,
                                      width: itemsize,
                                      child: SvgPicture.asset(e.address),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: elementState[itemlist.indexOf(e)]
                                          ? Container(
                                              width: itemsize,
                                              height: itemsize,
                                            )
                                          : Container(
                                              height: itemsize,
                                              width: itemsize,
                                              child:
                                                  SvgPicture.asset(e.address),
                                            ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
