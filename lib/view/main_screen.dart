import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tinderly/constants/colors.dart';
import 'package:tinderly/controller/addtofavplaces.dart';
import 'package:tinderly/controller/fetch_data.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:tinderly/controller/gotomaps.dart';
import 'package:tinderly/models/places.dart';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  final _getData = GetPlaceData();
  late CardController controller;
  AddFavouritePlaces _addFavouritePlaces = AddFavouritePlaces();
  List placestoShowAfter = [];

  @override
  void initState() {
    super.initState();
  }

  final storage = new FlutterSecureStorage();
  List places = [];
  void addtofav(Places placeInFav) async {
    if (await storage.read(key: "places") == null) {
      await storage.write(key: "places", value: jsonEncode([]));
    }
    await read();
    places = placestoShowAfter;
    places.add(placeInFav);
    await storage.write(key: "places", value: jsonEncode(places));
  }

// void deleteALl() async {
//   await storage.deleteAll();
// }

  List placestoShow = [];
  read() async {
    var res = await storage.read(key: "places");
    placestoShow = [];
    var decodedResponse = jsonDecode(res.toString()) as List;
    decodedResponse.forEach((element) {
      Places newplace = Places.fromJson(element);
      // setState(() {
      placestoShow.add(newplace);
      // });
    });
    setState(() {
      placestoShowAfter = placestoShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: pink,
        endDrawer: Container(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: Drawer(
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: turtoise,
                  ),
                  child: Text(
                    "Favourite List",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: canaryYellow),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: placestoShowAfter.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: canaryYellow,
                          title: Text(
                            placestoShowAfter[index].name,
                            style: TextStyle(fontSize: 15, color: turtoise),
                          ),
                          subtitle: Text(placestoShowAfter[index].country),
                          trailing: InkWell(
                            onTap: () {
                              List direction = placestoShowAfter[index]
                                  .googleMapsLink
                                  .toString()
                                  .substring(placestoShowAfter[index]
                                          .googleMapsLink
                                          .toString()
                                          .indexOf("q=") +
                                      2)
                                  .split(",");
                              // https://maps.google.com/maps?ll=49.61333,8.65389&spn=0.1,0.1&t=h&q=49.61333,8.65389
                              try {
                                MapUtils.openMap(direction[0], direction[1]
                                    // double.parse(direction[0]), double.parse(direction[1])
                                    );
                              } catch (e) {}
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  "assets/icons/pin.png",
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: canaryYellow,
          leading: Icon(
            CupertinoIcons.person_alt_circle_fill,
            size: 30,
          ),
          title: Text("Places App"),
          centerTitle: true,
          actions: [
            Builder(builder: (context) {
              return InkWell(
                onTap: () {
                  read();
                  // await read();
                  // setState(() async {
                  //   placestoShowAfter = await read();
                  // });

                  Scaffold.of(context).openEndDrawer();
                },
                child: Image.asset(
                  "assets/icons/hamburger.png",
                  width: 30,
                ),
              );
            }),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: newMethod(),
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<Places>> newMethod() {
    return FutureBuilder(
        future: _getData.fetchUsers(),
        builder: (context, snapshot) {

            if (snapshot.hasError) {
              return Center(child: Text("Make sure to have an internet connection",style: TextStyle(
                fontSize: 20,color:canaryYellow
              ),));
            }
          if (snapshot.connectionState == ConnectionState.done) {
            List arrays = snapshot.data as List;
            return TinderSwapCard(
              swipeUp: true,
              swipeDown: true,
              orientation: AmassOrientation.TOP,
              totalNum: _getData.data.length,
              stackNum: 3,
              swipeEdge: 4.0,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.width * 0.9,
              minWidth: MediaQuery.of(context).size.width * 0.8,
              minHeight: MediaQuery.of(context).size.width * 0.8,
              cardBuilder: (context, index) => Card(
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.orange,
                              Colors.orangeAccent,
                              Colors.red,
                              Colors.redAccent
                              //add more colors for gradient
                            ],
                            begin:
                                Alignment.topLeft, //begin of the gradient color
                            end: Alignment
                                .bottomRight, //end of the gradient color
                            stops: [
                              0,
                              0.2,
                              0.5,
                              0.8
                            ] //stops for individual color
                            //set the stops number equal to numbers of color
                            ),
                      ),
                    ),
                    Positioned(
                        top: 10,
                        right: 40,
                        child: InkWell(
                          onTap: () {
                            List direction = arrays[index]
                                .googleMapsLink
                                .toString()
                                .substring(arrays[index]
                                        .googleMapsLink
                                        .toString()
                                        .indexOf("q=") +
                                    2)
                                .split(",");
                            // https://maps.google.com/maps?ll=49.61333,8.65389&spn=0.1,0.1&t=h&q=49.61333,8.65389
                            try {
                              MapUtils.openMap(direction[0], direction[1]
                                  // double.parse(direction[0]), double.parse(direction[1])
                                  );
                            } catch (e) {}
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                "assets/icons/pin.png",
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                        top: 10,
                        right: 5,
                        child: InkWell(
                          onTap: () {
                            addtofav(arrays[index]);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                "assets/icons/favorite.png",
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                        left: 10,
                        top: 30,
                        child: Text(
                          arrays[index].name,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )),
                    Positioned(
                        left: 10,
                        top: 80,
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.red,
                            ),
                            Text(
                              arrays[index].country,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              cardController: controller = CardController(),
              swipeUpdateCallback:
                  (DragUpdateDetails details, Alignment align) {
                if (align.x < 0) {
                } else if (align.x > 0) {
                }
              },
              swipeCompleteCallback:
                  (CardSwipeOrientation orientation, int index) {
                if (orientation == CardSwipeOrientation.RIGHT) {
                  addtofav(arrays[index]);
                }
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

class myCard extends StatelessWidget {
  const myCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 300,
      color: Colors.green,
      child: Stack(
        children: [
          Positioned(
              top: 10,
              right: 40,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    "assets/icons/pin.png",
                    fit: BoxFit.scaleDown,
                  ),
                ),
              )),
          Positioned(
              top: 10,
              right: 5,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    "assets/icons/favorite.png",
                    fit: BoxFit.scaleDown,
                  ),
                ),
              )),
          Positioned(top: 20, child: Text("PLACE")),
          Positioned(top: 40, child: Text("Country")),
        ],
      ),
    );
  }
}
