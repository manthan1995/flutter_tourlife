import 'package:flutter/material.dart';
import 'package:tour_life/view/HomePage.dart';
import 'package:tour_life/view/JourneyPage.dart';
import 'package:tour_life/view/auth/screens/loginPage.dart';
import 'package:tour_life/view/gigPage.dart';
import 'package:tour_life/widget/ExpandedListAnimationWidget.dart';
import 'package:tour_life/widget/scrollbar.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JourneyPage(),
    );
  }
}

class DropDown extends StatefulWidget {
  @override
  _DropDownState createState() => _DropDownState();
}

List<String> _list = ['Dog', "Cat", "Mouse", 'Lion'];

class _DropDownState extends State<DropDown> {
  bool isStrechedDropDown = false;
  int? groupValue;
  String title = 'Select Animals';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Card(
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                                // height: 45,
                                width: double.infinity,
                                padding: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 151, 32, 32),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                constraints: BoxConstraints(
                                  minHeight: 45,
                                  minWidth: double.infinity,
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Text(
                                          title,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isStrechedDropDown =
                                                !isStrechedDropDown;
                                          });
                                        },
                                        child: Icon(isStrechedDropDown
                                            ? Icons.arrow_upward
                                            : Icons.arrow_downward))
                                  ],
                                )),
                            ExpandedSection(
                              expand: isStrechedDropDown,
                              height: 100,
                              child: MyScrollbar(
                                builder: (context, scrollController2) =>
                                    ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        controller: scrollController2,
                                        shrinkWrap: true,
                                        itemCount: _list.length,
                                        itemBuilder: (context, index) {
                                          return RadioListTile(
                                              title:
                                                  Text(_list.elementAt(index)),
                                              value: index,
                                              groupValue: groupValue,
                                              onChanged: (val) {
                                                setState(() {
                                                  groupValue =
                                                      int.parse(val.toString());
                                                  title =
                                                      _list.elementAt(index);
                                                });
                                              });
                                        }),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
