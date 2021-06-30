import 'package:flutter/material.dart';
import 'package:onlinre_polling/core/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlinre_polling/core/schemas/user-schemas.dart';
import 'package:onlinre_polling/core/widgets/countcard.dart';
import 'package:onlinre_polling/core/widgets/loading-animation.dart';
import 'package:onlinre_polling/core/widgets/success-animation.dart';
import 'package:onlinre_polling/core/widgets/web-bar.dart';
import 'package:onlinre_polling/screens/00-home/home.dart';
import 'package:onlinre_polling/screens/01-dashboard/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlinre_polling/core/authentication/firebase_auth.dart';

class DashboardPage extends StatefulWidget {
  static const String id = '/dashboard';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _eventsSelected = false;
  bool _historySelected = false;
  bool _settingsSelected = false;
  bool _createEventsSelected = true;
  bool _createNotificationSelected = false;
  bool _createGroupSelected = false;
  bool _exportDataSelected = false;
  bool _insightsSelected = false;
  bool _showLoading = false;
  bool _showSuccess = false;

  bool _activeEvents = false;
  bool _needResponse = true;
  bool _closedEvents = false;
  bool _onHoldEvents = false;

  String activeEventsCount = null;
  String needResponseCount = null;
  String closedEventsCount = null;
  String onHoldEventsCount = null;

  bool _takeNewEvent = true;

  String selctedEvent = 'One';
  String selectedEventType = 'One';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conformPasswordController =
      TextEditingController();

  final TextEditingController eventTitle = TextEditingController();
  final TextEditingController eventDescription = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialData();
    isAdmin = true;
  }

  void getInitialData() async {
    print('start');

    ///active events
    var events = await DataGets.activeEvents;
    setState(() {
      activeEventsCount = events.docs.length.toString();
    });

    ///need response
    events = await DataGets.needResponse;
    setState(() {
      needResponseCount = events.docs.length.toString();
    });

    ///closed events
    events = await DataGets.closedEvents;
    setState(() {
      closedEventsCount = events.docs.length.toString();
    });

    ///on hold events
    events = await DataGets.closedEvents;
    setState(() {
      onHoldEventsCount = events.docs.length.toString();
    });

    print('ended');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background.lightBlue,
      body: Stack(
        children: [
          ///Content
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSideBar(context),
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width - 250,
                  child: Column(
                    children: [
                      if (_eventsSelected) buildEventsContent(),
                      if (_historySelected) buildHistoryContent(),
                      if (_settingsSelected) buildSettingsContent(),
                      if (_createEventsSelected) buildCreateEventsContent(),
                      if (_createNotificationSelected)
                        buildCreateNotificationsContent(),
                      if (_createGroupSelected) buildCreateGroupContent(),
                      if (_exportDataSelected) buildExportDataContent(),
                      if (_insightsSelected) buildInsightsContent(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (_takeNewEvent) buildNewEventPrompt(),

          ///Loading animation
          if (_showLoading) LoadingAnimation(),

          ///Success animation
          if (_showSuccess) SuccessAnimation()
        ],
      ),
    );
  }

  Widget buildSettingsContent() {
    return Column(
      children: [
        WebBar(
          title: 'Settings',
        ),
        Column(
          children: [
            ///Name
            Container(
              width: 300,
              padding: EdgeInsets.only(top: 50),
              child: TextField(
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Password
            Container(
              width: 300,
              padding: EdgeInsets.only(top: 50),
              child: TextField(
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                obscureText: true,
                obscuringCharacter: '*',
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Confirm Password
            Container(
              width: 300,
              padding: EdgeInsets.only(top: 50),
              child: TextField(
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                obscureText: true,
                obscuringCharacter: '*',
                controller: conformPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  hintStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),

            ///Update
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 100,
                  bottom: 5,
                  left: 30,
                  right: 30,
                ),
                child: CustomButton(
                  text: 'Update',
                  onTap: () {
                    print('update');
                    updateNameAndPassword();
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildEventsContent() {
    return Container(
      child: Column(
        children: [
          WebBar(
            title: 'Events',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CountCards(
                title: 'Active Events',
                count: activeEventsCount ?? '-',
                selected: _activeEvents,
                onTap: () {
                  setState(() {
                    _activeEvents = true;
                    _needResponse = false;
                    _closedEvents = false;
                    _onHoldEvents = false;
                  });
                },
              ),
              CountCards(
                title: 'Need Response',
                count: needResponseCount ?? '-',
                selected: _needResponse,
                onTap: () {
                  setState(() {
                    _activeEvents = false;
                    _needResponse = true;
                    _closedEvents = false;
                    _onHoldEvents = false;
                  });
                },
              ),
              CountCards(
                title: 'Closed Events',
                count: closedEventsCount ?? '-',
                selected: _closedEvents,
                onTap: () {
                  setState(() {
                    _activeEvents = false;
                    _needResponse = false;
                    _closedEvents = true;
                    _onHoldEvents = false;
                  });
                },
              ),
              // CountCards(
              //   title: 'On Hold',
              //   count: onHoldEventsCount ?? '-',
              //   selected: _onHoldEvents,
              //   onTap: () {
              //     setState(() {
              //       _activeEvents = false;
              //       _needResponse = false;
              //       _closedEvents = false;
              //       _onHoldEvents = true;
              //     });
              //   },
              // ),
            ],
          ),
          if (_activeEvents) buildActiveEvents(),
          if (_needResponse) buildNeedResponse(),
          if (_closedEvents) buildClosedEvents(),
          // if (_onHoldEvents) buildOnHoldEvents(),
        ],
      ),
    );
  }

  Widget buildHistoryContent() {
    return Column(
      children: [
        WebBar(
          title: 'History',
        ),
      ],
    );
  }

  Widget buildCreateEventsContent() {
    return Column(
      children: [
        WebBar(
          title: 'Manage Events',
        ),
        Center(
          child: Container(
            width: 1000,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              color: Color.fromRGBO(255, 255, 255, 1),
              border: Border.all(
                color: Color.fromRGBO(223, 224, 235, 1),
                width: 1,
              ),
            ),
            margin: EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///All Events
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                    left: 40,
                    bottom: 40,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Events',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.mulish(
                          color: Color.fromRGBO(37, 39, 51, 1),
                          fontSize: 19,
                          letterSpacing: 0.4000000059604645,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 50),
                        child: Center(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _takeNewEvent = true;
                              });
                            },
                            icon: Container(
                              margin: const EdgeInsets.only(
                                  left: 10, top: 10, bottom: 10),
                              child: Icon(
                                Icons.add,
                                size: 14,
                                color: AppColor.blue,
                              ),
                            ),
                            label: Container(
                              margin: const EdgeInsets.all(10),
                              child: Text(
                                ' Event ',
                                style: GoogleFonts.mulish(
                                    color: AppColor.blue,
                                    fontSize: 14,
                                    letterSpacing: 0.20000000298023224,
                                    fontWeight: FontWeight.normal,
                                    height: 1.4285714285714286),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: DataStreams.activeEvents,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: snapshot.data.docs.map((document) {
                          return EventListItem(
                            title: document['title'],
                            date: document['date'],
                            priority: document['priority'],
                            status: document['status'],
                          );
                        }).toList(),
                      );
                    }),
                Container(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNewEventPrompt() {
    buildPage1() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Add a new event
              Text(
                'Add a new Event',
                textAlign: TextAlign.left,
                style: GoogleFonts.mulish(
                  color: Color.fromRGBO(37, 39, 51, 1),
                  fontSize: 19,
                  letterSpacing: 0.4000000059604645,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),

              ///Title Textfield
              Container(
                width: 500,
                padding: EdgeInsets.only(top: 50),
                child: TextField(
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  controller: eventTitle,
                  maxLength: 100,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),

              ///Description Textfield
              Container(
                width: 500,
                height: 200,
                padding: EdgeInsets.only(top: 50),
                child: TextField(
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  controller: eventDescription,
                  minLines: 1,
                  maxLines: 20,
                  maxLength: 1000,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Question Type
                Container(
                  height: 50,
                  width: 200,
                  margin: EdgeInsets.only(top: 15),
                  child: DropdownButton<String>(
                    value: selectedEventType,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 20,
                    elevation: 16,
                    isExpanded: true,
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                    underline: Container(
                      height: 1.5,
                      width: 300,
                      color: Colors.black87,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        selectedEventType = newValue;
                      });
                    },
                    items: <String>['One', 'Two', 'Free', 'Four']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),

                ///Priority
                Container(
                  height: 50,
                  width: 200,
                  margin: EdgeInsets.only(top: 70),
                  child: DropdownButton<String>(
                    value: selectedEventType,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 20,
                    elevation: 16,
                    isExpanded: true,
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                    underline: Container(
                      height: 1.5,
                      width: 300,
                      color: Colors.black87,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        selectedEventType = newValue;
                      });
                    },
                    items: <String>['One', 'Two', 'Free', 'Four']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    buildPage2() {
      return Text('Page - 2');
    }

    bool _showPage1 = true;
    bool _showPage2 = false;

    return Container(
        color: Colors.white70,
        child: Center(
          child: Container(
            width: 1000,
            height: 600,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.28999999165534973),
                    offset: Offset(3, 4),
                    blurRadius: 30)
              ],
              color: AppColor.background.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_showPage1) buildPage1(),
                  if (_showPage2) buildPage2(),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                            textColor: Colors.black,
                            bgColor: AppColor.white,
                            text: 'Cancel',
                            onTap: () {
                              setState(() {
                                _takeNewEvent = false;
                              });
                            }),
                        CustomButton(
                            text: 'Continue',
                            onTap: () {
                              print('tapped');
                              if (_showPage1)
                                setState(() {
                                  _showPage1 = false;
                                  _showPage2 = true;
                                });
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildCreateNotificationsContent() {
    return Column(
      children: [
        WebBar(
          title: 'Create Notifications',
        ),
        Center(
          child: Container(
            width: 1000,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              color: Color.fromRGBO(255, 255, 255, 1),
              border: Border.all(
                color: Color.fromRGBO(223, 224, 235, 1),
                width: 1,
              ),
            ),
            margin: EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///All Notifications
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                    left: 40,
                    bottom: 40,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Notifications',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.mulish(
                          color: Color.fromRGBO(37, 39, 51, 1),
                          fontSize: 19,
                          letterSpacing: 0.4000000059604645,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 50),
                        child: Center(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Respond to button press
                            },
                            icon: Container(
                              margin: const EdgeInsets.only(
                                  left: 10, top: 10, bottom: 10),
                              child: Icon(
                                Icons.add,
                                size: 14,
                                color: AppColor.blue,
                              ),
                            ),
                            label: Container(
                              margin: const EdgeInsets.all(10),
                              child: Text(
                                ' Notification ',
                                style: GoogleFonts.mulish(
                                    color: AppColor.blue,
                                    fontSize: 14,
                                    letterSpacing: 0.20000000298023224,
                                    fontWeight: FontWeight.normal,
                                    height: 1.4285714285714286),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: DataStreams.activeEvents,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: snapshot.data.docs.map((document) {
                          return EventListItem(
                            title: document['title'],
                            date: document['date'],
                            priority: document['priority'],
                            status: document['status'],
                          );
                        }).toList(),
                      );
                    }),
                Container(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCreateGroupContent() {
    return Column(
      children: [
        WebBar(
          title: 'Manage Groups',
        ),
        Center(
          child: Container(
            width: 1000,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              color: Color.fromRGBO(255, 255, 255, 1),
              border: Border.all(
                color: Color.fromRGBO(223, 224, 235, 1),
                width: 1,
              ),
            ),
            margin: EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///All Groups
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                    left: 40,
                    bottom: 40,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Groups',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.mulish(
                          color: Color.fromRGBO(37, 39, 51, 1),
                          fontSize: 19,
                          letterSpacing: 0.4000000059604645,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 50),
                        child: Center(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Respond to button press
                            },
                            icon: Container(
                              margin: const EdgeInsets.only(
                                  left: 10, top: 10, bottom: 10),
                              child: Icon(
                                Icons.add,
                                size: 14,
                                color: AppColor.blue,
                              ),
                            ),
                            label: Container(
                              margin: const EdgeInsets.all(10),
                              child: Text(
                                ' Group ',
                                style: GoogleFonts.mulish(
                                    color: AppColor.blue,
                                    fontSize: 14,
                                    letterSpacing: 0.20000000298023224,
                                    fontWeight: FontWeight.normal,
                                    height: 1.4285714285714286),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: DataStreams.activeEvents,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: snapshot.data.docs.map((document) {
                          return EventListItem(
                            title: document['title'],
                            date: document['date'],
                            priority: document['priority'],
                            status: document['status'],
                          );
                        }).toList(),
                      );
                    }),
                Container(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildExportDataContent() {
    return Column(
      children: [
        WebBar(
          title: 'Export Data',
        ),
        Column(
          children: [
            Container(
              width: 300,
              child: DropdownButton<String>(
                value: selctedEvent,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 20,
                elevation: 16,
                isExpanded: true,
                style: GoogleFonts.mulish(color: Colors.black, fontSize: 16),
                underline: Container(
                  height: 2,
                  width: 300,
                  color: Colors.black87,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    selctedEvent = newValue;
                  });
                },
                items: <String>['One', 'Two', 'Free', 'Four']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),

            ///Export
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 100,
                  bottom: 5,
                  left: 30,
                  right: 30,
                ),
                child: CustomButton(
                  text: 'Export',
                  onTap: () async {
                    setState(() {
                      _showLoading = true;
                    });

                    await Future.delayed(Duration(seconds: 2));

                    setState(() {
                      _showLoading = false;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildInsightsContent() {
    return Column(
      children: [
        WebBar(
          title: 'Insights',
        ),
      ],
    );
  }

  Widget buildNeedResponse() {
    return Center(
      child: Container(
        width: 1000,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(
            color: Color.fromRGBO(223, 224, 235, 1),
            width: 1,
          ),
        ),
        margin: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
                left: 40,
                bottom: 40,
              ),
              child: Text(
                'Need an Immedete Response',
                textAlign: TextAlign.left,
                style: GoogleFonts.mulish(
                  color: Color.fromRGBO(37, 39, 51, 1),
                  fontSize: 19,
                  letterSpacing: 0.4000000059604645,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
            StreamBuilder(
                stream: DataStreams.needResponse,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: snapshot.data.docs.map((document) {
                      return EventListItem(
                        title: document['title'],
                        date: document['date'],
                        priority: document['priority'],
                        status: document['status'],
                      );
                    }).toList(),
                  );
                }),
            Container(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Widget buildActiveEvents() {
    return Center(
      child: Container(
        width: 1000,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(
            color: Color.fromRGBO(223, 224, 235, 1),
            width: 1,
          ),
        ),
        margin: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Active Events
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
                left: 40,
                bottom: 40,
              ),
              child: Text(
                'Active Events',
                textAlign: TextAlign.left,
                style: GoogleFonts.mulish(
                  color: Color.fromRGBO(37, 39, 51, 1),
                  fontSize: 19,
                  letterSpacing: 0.4000000059604645,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
            StreamBuilder(
                stream: DataStreams.activeEvents,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: snapshot.data.docs.map((document) {
                      return EventListItem(
                        title: document['title'],
                        date: document['date'],
                        priority: document['priority'],
                        status: document['status'],
                      );
                    }).toList(),
                  );
                }),
            Container(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Widget buildClosedEvents() {
    return Center(
      child: Container(
        width: 1000,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(
            color: Color.fromRGBO(223, 224, 235, 1),
            width: 1,
          ),
        ),
        margin: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
                left: 40,
                bottom: 40,
              ),
              child: Text(
                'Closed Events',
                textAlign: TextAlign.left,
                style: GoogleFonts.mulish(
                  color: Color.fromRGBO(37, 39, 51, 1),
                  fontSize: 19,
                  letterSpacing: 0.4000000059604645,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
            StreamBuilder(
                stream: DataStreams.closedEvents,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: snapshot.data.docs.map((document) {
                      return EventListItem(
                        title: document['title'],
                        date: document['date'],
                        isClosed: true,
                        priority: document['priority'],
                      );
                    }).toList(),
                  );
                }),
            Container(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Widget buildOnHoldEvents() {
    return Center(
      child: Container(
        width: 1000,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(
            color: Color.fromRGBO(223, 224, 235, 1),
            width: 1,
          ),
        ),
        margin: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
                left: 40,
                bottom: 40,
              ),
              child: Text(
                'On Hold',
                textAlign: TextAlign.left,
                style: GoogleFonts.mulish(
                  color: Color.fromRGBO(37, 39, 51, 1),
                  fontSize: 19,
                  letterSpacing: 0.4000000059604645,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
            EventListItem(
              title: 'Online LMS Feedback',
              date: '23 May 2020',
            ),
            EventListItem(
              title: 'Online LMS Feedback',
              date: '23 May 2020',
            ),
            EventListItem(
              title: 'Online LMS Feedback',
              date: '23 May 2020',
            ),
            EventListItem(
              title: 'Online LMS Feedback',
              date: '23 May 2020',
            ),
            EventListItem(
              title: 'Online LMS Feedback',
              date: '23 May 2020',
            ),
            EventListItem(
              title: 'Online LMS Feedback',
              date: '23 May 2020',
            ),
            EventListItem(
              title: 'Online LMS Feedback',
              date: '23 May 2020',
            ),
            EventListItem(
              title: 'Online LMS Feedback',
              date: '23 May 2020',
            ),
            EventListItem(
              title: 'Online LMS Feedback',
              date: '23 May 2020',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSideBar(BuildContext context) {
    return Container(
      width: 250,
      height: MediaQuery.of(context).size.height,
      color: AppColor.background.darkGrey,
      child: Column(
        children: [
          Container(
            height: 100,
            child: Center(
              child: Text(
                'Dashboard',
                style: GoogleFonts.mulish(
                  textStyle: TextStyle(
                    color: AppColor.text.grey,
                    fontSize: 19,
                    letterSpacing: 0.4000000059604645,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),

          ///Events
          MenuItem(
            text: 'Events',
            icon: Icons.event_available,
            isSelected: _eventsSelected,
            onTap: () {
              setState(() {
                _eventsSelected = true;
                _historySelected = false;
                _settingsSelected = false;
                _createEventsSelected = false;
                _createNotificationSelected = false;
                _createGroupSelected = false;
                _insightsSelected = false;
                _exportDataSelected = false;
              });
            },
          ),

          ///History
          MenuItem(
            text: 'History',
            icon: Icons.history,
            isSelected: _historySelected,
            onTap: () {
              setState(() {
                _eventsSelected = false;
                _historySelected = true;
                _settingsSelected = false;
                _createEventsSelected = false;
                _createNotificationSelected = false;
                _createGroupSelected = false;
                _insightsSelected = false;
                _exportDataSelected = false;
              });
            },
          ),

          ///Insights
          MenuItem(
            text: 'Insights',
            icon: Icons.bar_chart,
            isSelected: _insightsSelected,
            onTap: () {
              setState(() {
                _insightsSelected = true;
                _createGroupSelected = false;
                _createNotificationSelected = false;
                _createEventsSelected = false;
                _eventsSelected = false;
                _historySelected = false;
                _settingsSelected = false;
                _exportDataSelected = false;
              });
            },
          ),

          ///Manage Events
          MenuItem(
            text: 'Manage Events',
            icon: Icons.add,
            isSelected: _createEventsSelected,
            onTap: () {
              setState(() {
                _createEventsSelected = true;
                _eventsSelected = false;
                _historySelected = false;
                _settingsSelected = false;
                _createNotificationSelected = false;
                _createGroupSelected = false;
                _insightsSelected = false;
                _exportDataSelected = false;
              });
            },
          ),

          ///Manage Groups
          MenuItem(
            text: 'Manage Groups',
            icon: Icons.group_add,
            isSelected: _createGroupSelected,
            onTap: () {
              setState(() {
                _createGroupSelected = true;
                _createNotificationSelected = false;
                _createEventsSelected = false;
                _eventsSelected = false;
                _historySelected = false;
                _settingsSelected = false;
                _exportDataSelected = false;
                _insightsSelected = false;
              });
            },
          ),

          ///Create Notifications
          MenuItem(
            text: 'Create Notifications',
            icon: Icons.add_alert,
            isSelected: _createNotificationSelected,
            onTap: () {
              setState(() {
                _createNotificationSelected = true;
                _createEventsSelected = false;
                _eventsSelected = false;
                _historySelected = false;
                _settingsSelected = false;
                _createGroupSelected = false;
                _insightsSelected = false;
                _exportDataSelected = false;
              });
            },
          ),

          ///Export Data
          MenuItem(
            text: 'Export Data',
            icon: Icons.download_rounded,
            isSelected: _exportDataSelected,
            onTap: () {
              setState(() {
                _exportDataSelected = true;
                _createEventsSelected = false;
                _eventsSelected = false;
                _historySelected = false;
                _settingsSelected = false;
                _createNotificationSelected = false;
                _createGroupSelected = false;
                _insightsSelected = false;
              });
            },
          ),
          Container(
            width: 240,
            height: 1,
            margin: EdgeInsets.symmetric(vertical: 10),
            color: AppColor.text.grey.withOpacity(0.2),
          ),
          MenuItem(
            text: 'Settings',
            icon: Icons.settings,
            isSelected: _settingsSelected,
            onTap: () {
              setState(() {
                _exportDataSelected = false;
                _eventsSelected = false;
                _historySelected = false;
                _settingsSelected = true;
                _createEventsSelected = false;
                _createNotificationSelected = false;
                _createGroupSelected = false;
                _insightsSelected = false;
              });
            },
          ),
        ],
      ),
    );
  }

  updateNameAndPassword() async {
    User user = FirebaseAuthentication.getUser();
    if (passwordController.text != null ||
        passwordController.text.trim().isNotEmpty)
      user.updatePassword(passwordController.text);
    if (nameController.text != null || nameController.text.trim().isNotEmpty)
      user.updateDisplayName(nameController.text);
    setState(() {
      _showSuccess = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _showSuccess = false;
    });
  }
}
