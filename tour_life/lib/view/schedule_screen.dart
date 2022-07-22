import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tour_life/constant/colorses.dart';
import 'package:tour_life/constant/strings.dart';
import 'package:tour_life/view/all_data/api_provider/all_api_provider.dart';
import 'package:tour_life/view/car_journey.dart';
import 'package:tour_life/view/flight_journey_screen.dart';
import 'package:tour_life/view/set_time_screen.dart';
import 'package:tour_life/widget/commanAppBar.dart';
import 'package:tour_life/widget/commanHeaderBg.dart';
import '../constant/date_time.dart';
import '../constant/images.dart';
import '../constant/preferences_key.dart';
import 'all_data/model/all_data_model.dart';
import 'all_data/provider/all_provider.dart';

class ScheduleScreen extends StatefulWidget {
  String userName;
  String location;
  int id;
  int? userId;
  List<Gigs> gigsdetails = [];

  ScheduleScreen(
      {Key? key,
      required this.id,
      this.userId,
      required this.userName,
      required this.gigsdetails,
      required this.location})
      : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late AllDataModel prefData;
  List<Schedule>? allDataList = [];
  List<Schedule>? scheduleList = [];
  List finaldatelist = [];
  DateTime? d;
  DateTime? a;

  @override
  void initState() {
    var data = preferences.getString(Keys.allReponse);
    prefData = AllDataModel.fromJson(jsonDecode(data!));
    scheduleList = prefData.result!.schedule;
    print(widget.userId);

    for (int i = 0; i < scheduleList!.length; i++) {
      print(prefData.result!.schedule![i].user);
      if (widget.userId
          .toString()
          .contains(prefData.result!.schedule![i].user.toString())) {
        if (prefData.result!.schedule![i].gig == widget.id) {
          allDataList!.add(prefData.result!.schedule![i]);
        }
      }
    }

    List datelist = [];
    for (int i = 0; i < allDataList!.length; i++) {
      datelist.add(getDate(dates: allDataList![i].departTime));
    }
    finaldatelist = datelist.toSet().toList();

    allDataList!.sort((a, b) {
      return DateTime.parse(a.departTime!)
          .compareTo(DateTime.parse(b.departTime!));
    });

    DateFormat inputFormat = DateFormat('E dd MMM');

    finaldatelist.sort((a, b) {
      return inputFormat
          .parse(a.toString())
          .compareTo(inputFormat.parse(b.toString()));
    });

    DateTime as = DateTime.parse(allDataList![0].arrivalTime.toString());
    print("object");
    print(as);
    print(DateTime.parse(allDataList![0].departTime.toString())
        .difference(DateTime.parse(allDataList![0].arrivalTime.toString()))
        .inDays);
    print(finaldatelist);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppbar(
        context: context,
        text: Strings.scheduleStr,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colorses.white,
          child: Column(
            children: [
              Stack(
                children: [
                  CommanHeaderBg(
                    title: widget.userName,
                    subTitle: widget.location,
                  ),
                  buildForgroundPart(size: size),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildForgroundPart({Size? size}) {
    return Container(
      margin: EdgeInsets.only(
        left: size!.height * 0.02,
        right: size.height * 0.02,
        top: size.height * 0.15,
      ),
      padding: EdgeInsets.all(15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        color: Colorses.red,
        boxShadow: [
          BoxShadow(
            color: Colorses.grey,
            blurRadius: 2.0,
            spreadRadius: 0.0,
          )
        ],
      ),
      width: size.width,
      child: Column(
        children: [
          buildTravellerPart(size: size),
          buildDriverCard(size: size),
        ],
      ),
    );
  }

  Widget buildDriverCard({Size? size}) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: size!.height * 0.01, horizontal: size.width * 0.03),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: finaldatelist.length,
              itemBuilder: ((context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25),
                          ),
                          color: Colorses.black,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          finaldatelist[index],
                          style: TextStyle(
                              color: Colorses.white,
                              fontFamily: 'Inter-Medium',
                              fontSize: 15),
                        )),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allDataList!.length,
                        itemBuilder: ((context, i) {
                          return finaldatelist[index] ==
                                  getDate(dates: allDataList![i].departTime)
                              ? Column(
                                  children: [
                                    Container(
                                      child: buildListItem(index: i),
                                    )
                                  ],
                                )
                              : SizedBox();
                        }))
                  ],
                );
              })),
        ));
  }

  Widget buildListItem({int? index}) {
    int hourse = DateTime.parse(allDataList![index!].arrivalTime.toString())
        .difference(DateTime.parse(allDataList![index].departTime.toString()))
        .inHours;
    int minit = DateTime.parse(allDataList![index].arrivalTime.toString())
            .difference(
                DateTime.parse(allDataList![index].departTime.toString()))
            .inMinutes %
        60;
    return InkWell(
      onTap: () {
        if (allDataList![index].type.toString().contains("flight")) {
          print(allDataList!);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FlightJourneyPage(
                      id: index,
                      flightDataList: allDataList,
                      userName: widget.userName,
                      location: widget.location,
                    )),
          );
        } else if (allDataList![index].type.toString().contains("cab")) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CarJourney(
                      id: index,
                      carDataList: allDataList,
                      userName: widget.userName,
                      location: widget.location,
                    )),
          );
        } else if (allDataList![index].type.toString().contains("settime")) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SetTimeScreen(
                      id: index,
                      setTimeDataList: allDataList,
                      userName: widget.userName,
                      location: widget.location,
                    )),
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          allDataList![index].type.toString().contains("flight")
              ? SvgPicture.asset(
                  Images.planeImage,
                )
              : allDataList![index].type.toString().contains("cab")
                  ? SvgPicture.asset(
                      Images.carImage,
                    )
                  : SvgPicture.asset(
                      Images.settimeIconImage,
                    ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: "${getTime(times: allDataList![index].departTime)}",
                    style: TextStyle(
                      color: Colorses.grey,
                      fontSize: 15,
                      fontFamily: 'Inter-SemiBold',
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: allDataList![index]
                                  .type
                                  .toString()
                                  .contains("settime")
                              ? " - Set Time"
                              : " - Flight from ${allDataList![index].departLocation} to ${allDataList![index].arrivalLocation}",
                          style: TextStyle(color: Colorses.red)),
                    ],
                  ),
                ),
                Text(
                  "${widget.userName} at ${widget.location} - ${hourse == 0 ? "" : "$hourse h"} ${minit == 0 ? "" : "$minit m"}",
                  style: TextStyle(
                    color: Colorses.black,
                    fontSize: 12,
                    fontFamily: 'Inter-Medium',
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTravellerPart({Size? size}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size!.width * 0.08,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.travellerStr,
                style: TextStyle(
                  color: Colorses.white,
                  fontSize: 14,
                  fontFamily: 'Inter-Medium',
                ),
              ),
              Text(
                Strings.selectUserStr,
                style: TextStyle(
                  color: Colorses.white,
                  fontSize: 16,
                  fontFamily: 'Inter-Medium',
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_drop_down_rounded,
            color: Colorses.black,
            size: 50,
          )
        ],
      ),
    );
  }

  Widget buildViewLine({Size? size, double? height}) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size!.height * 0.01,
      ),
      width: size.width / 1.2,
      height: height,
      color: Colorses.black,
    );
  }
}
