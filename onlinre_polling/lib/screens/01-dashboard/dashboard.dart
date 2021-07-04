import 'package:flutter/material.dart';
import 'package:onlinre_polling/core/Models/event.dart';
import 'package:onlinre_polling/core/Models/poll.dart';
import 'package:onlinre_polling/core/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlinre_polling/core/schemas/user-schemas.dart';
import 'package:onlinre_polling/core/services/firebase_services.dart';
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
  ///Global
  bool _showLoading = false;
  bool _showSuccess = false;
  Event _currentEvent = Event(
    id: 0,
    title: 'This is Title',
    des: 'This is thingThis is thingThis is thingThis is thing',
    isClosed: false,
    date: '23-90-2000',
    priority: 1,
    status: 1,
    type: '',
    question: 'This is the questions',
  );

  ///Menu bar
  bool _eventsSelected = false;
  bool _historySelected = false;
  bool _settingsSelected = false;
  bool _createEventsSelected = false;
  bool _createPollsSelected = true;
  bool _createNotificationSelected = false;
  bool _createGroupSelected = false;
  bool _exportDataSelected = false;
  bool _insightsSelected = false;

  ///Add a new Poll
  bool _takeNewPoll = true;

  final TextEditingController pollTitleController = TextEditingController();
  final TextEditingController pollDescriptionController =
      TextEditingController();
  final TextEditingController pollQuestionController = TextEditingController();
  final TextEditingController pollPartyNamesController =
      TextEditingController();
  final TextEditingController pollTotalPartiesController =
      TextEditingController();
  bool _showPollConformDialoge = false;
  bool _showPollPage1 = true;
  bool _showPollPage2 = false;
  Poll poll = Poll();

  ///Add new Event
  bool _takeNewEvent = false;
  String selectedPriyority = 'High';
  bool _showEventPage1 = true;
  bool _showEventConformDialoge = false;
  bool _showEventPage2 = false;
  Event event = Event();
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController eventDescriptionController =
      TextEditingController();
  final TextEditingController eventQuestionController = TextEditingController();
  final TextEditingController eventAnswerController = TextEditingController();

  ///Add new Poll
  ///new User Response for event
  bool _takeUserResponse = false;
  bool _showAnswerConformDialoge = false;

  ///new User Response for poll
  ///Settings
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conformPasswordController =
      TextEditingController();

  ///Export
  String selectedExportEvent = 'One';

  ///insights
  ///All Events
  bool _activeEvents = false;
  bool _needResponse = true;
  bool _closedEvents = false;
  bool _onHoldEvents = false;

  String activeEventsCount = null;
  String needResponseCount = null;
  String closedEventsCount = null;
  String onHoldEventsCount = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialData();
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
                      if (_createPollsSelected) buildCreatePollsContent(),
                      if (_settingsSelected) buildSettingsContent(),
                      if (_createEventsSelected) buildCreateEventsContent(),
                      // if (_createNotificationSelected)
                      // buildCreateNotificationsContent(),
                      // if (_createGroupSelected) buildCreateGroupContent(),
                      if (_exportDataSelected) buildExportDataContent(),
                      if (_insightsSelected) buildInsightsContent(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (_takeNewEvent) buildNewEventPrompt(),

          if (_takeNewPoll) buildNewPollPrompt(),

          if (_takeUserResponse) buildUserEventPrompt(),

          ///Loading animation
          if (_showLoading) LoadingAnimation(),

          ///Success animation
          if (_showSuccess) SuccessAnimation()
        ],
      ),
    );
  }

  ///==============================================Contents
  ///Settings
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

  ///Events
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

  ///Events
  Widget buildCreatePollsContent() {
    return Column(
      children: [
        WebBar(
          title: 'Manage Polls',
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
                ///All Polls
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
                        'All Polls',
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
                              print('Add poll');
                              setState(() {
                                _takeNewPoll = true;
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
                                ' Poll ',
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
                    stream: DataStreams.events,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: snapshot.data.docs.map((document) {
                          return buildPollListItem(
                            title: document['title'],
                            date: document['date'],
                            status: document['status'],
                            priority: document['priority'],
                            isClosed: document['isClosed'],
                            des: document['des'],
                            type: document['type'],
                            id: document['id'],
                            question: document['question'],
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

  ///History
  // Widget buildHistoryContent() {
  //   return Column(
  //     children: [
  //       WebBar(
  //         title: 'History',
  //       ),
  //     ],
  //   );
  // }

  ///Notifications
  // Widget buildCreateNotificationsContent() {
  //   return Column(
  //     children: [
  //       WebBar(
  //         title: 'Create Notifications',
  //       ),
  //       Center(
  //         child: Container(
  //           width: 1000,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(8),
  //             ),
  //             color: Color.fromRGBO(255, 255, 255, 1),
  //             border: Border.all(
  //               color: Color.fromRGBO(223, 224, 235, 1),
  //               width: 1,
  //             ),
  //           ),
  //           margin: EdgeInsets.only(top: 50),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               ///All Notifications
  //               Padding(
  //                 padding: const EdgeInsets.only(
  //                   top: 40,
  //                   left: 40,
  //                   bottom: 40,
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       'All Notifications',
  //                       textAlign: TextAlign.left,
  //                       style: GoogleFonts.mulish(
  //                         color: Color.fromRGBO(37, 39, 51, 1),
  //                         fontSize: 19,
  //                         letterSpacing: 0.4000000059604645,
  //                         fontWeight: FontWeight.bold,
  //                         height: 1,
  //                       ),
  //                     ),
  //                     Container(
  //                       margin: EdgeInsets.only(right: 50),
  //                       child: Center(
  //                         child: OutlinedButton.icon(
  //                           onPressed: () {
  //                             // Respond to button press
  //                           },
  //                           icon: Container(
  //                             margin: const EdgeInsets.only(
  //                                 left: 10, top: 10, bottom: 10),
  //                             child: Icon(
  //                               Icons.add,
  //                               size: 14,
  //                               color: AppColor.blue,
  //                             ),
  //                           ),
  //                           label: Container(
  //                             margin: const EdgeInsets.all(10),
  //                             child: Text(
  //                               ' Notification ',
  //                               style: GoogleFonts.mulish(
  //                                   color: AppColor.blue,
  //                                   fontSize: 14,
  //                                   letterSpacing: 0.20000000298023224,
  //                                   fontWeight: FontWeight.normal,
  //                                   height: 1.4285714285714286),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               StreamBuilder(
  //                   stream: DataStreams.activeEvents,
  //                   builder: (BuildContext context,
  //                       AsyncSnapshot<QuerySnapshot> snapshot) {
  //                     if (!snapshot.hasData) {
  //                       return Center(
  //                         child: CircularProgressIndicator(),
  //                       );
  //                     }
  //                     return Column(
  //                       children: snapshot.data.docs.map((document) {
  //                         return buildEventListItem(
  //                           title: document['title'],
  //                           date: document['date'],
  //                           status: document['status'],
  //                           priority: document['priority'],
  //                           isClosed: document['isClosed'],
  //                           des: document['des'],
  //                           type: document['type'],
  //                           id: document['id'],
  //                           question: document['question'],
  //                         );
  //                       }).toList(),
  //                     );
  //                   }),
  //               Container(
  //                 height: 100,
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  ///Create Group
  // Widget buildCreateGroupContent() {
  //   return Column(
  //     children: [
  //       WebBar(
  //         title: 'Manage Groups',
  //       ),
  //       Center(
  //         child: Container(
  //           width: 1000,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(8),
  //             ),
  //             color: Color.fromRGBO(255, 255, 255, 1),
  //             border: Border.all(
  //               color: Color.fromRGBO(223, 224, 235, 1),
  //               width: 1,
  //             ),
  //           ),
  //           margin: EdgeInsets.only(top: 50),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               ///All Groups
  //               Padding(
  //                 padding: const EdgeInsets.only(
  //                   top: 40,
  //                   left: 40,
  //                   bottom: 40,
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       'All Groups',
  //                       textAlign: TextAlign.left,
  //                       style: GoogleFonts.mulish(
  //                         color: Color.fromRGBO(37, 39, 51, 1),
  //                         fontSize: 19,
  //                         letterSpacing: 0.4000000059604645,
  //                         fontWeight: FontWeight.bold,
  //                         height: 1,
  //                       ),
  //                     ),
  //                     Container(
  //                       margin: EdgeInsets.only(right: 50),
  //                       child: Center(
  //                         child: OutlinedButton.icon(
  //                           onPressed: () {
  //                             // Respond to button press
  //                           },
  //                           icon: Container(
  //                             margin: const EdgeInsets.only(
  //                                 left: 10, top: 10, bottom: 10),
  //                             child: Icon(
  //                               Icons.add,
  //                               size: 14,
  //                               color: AppColor.blue,
  //                             ),
  //                           ),
  //                           label: Container(
  //                             margin: const EdgeInsets.all(10),
  //                             child: Text(
  //                               ' Group ',
  //                               style: GoogleFonts.mulish(
  //                                   color: AppColor.blue,
  //                                   fontSize: 14,
  //                                   letterSpacing: 0.20000000298023224,
  //                                   fontWeight: FontWeight.normal,
  //                                   height: 1.4285714285714286),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               StreamBuilder(
  //                   stream: DataStreams.activeEvents,
  //                   builder: (BuildContext context,
  //                       AsyncSnapshot<QuerySnapshot> snapshot) {
  //                     if (!snapshot.hasData) {
  //                       return Center(
  //                         child: CircularProgressIndicator(),
  //                       );
  //                     }
  //                     return Column(
  //                       children: snapshot.data.docs.map((document) {
  //                         return buildEventListItem(
  //                           title: document['title'],
  //                           date: document['date'],
  //                           status: document['status'],
  //                           priority: document['priority'],
  //                           isClosed: document['isClosed'],
  //                           des: document['des'],
  //                           type: document['type'],
  //                           id: document['id'],
  //                           question: document['question'],
  //                         );
  //                       }).toList(),
  //                     );
  //                   }),
  //               Container(
  //                 height: 100,
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  ///New Event
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
                    stream: DataStreams.events,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: snapshot.data.docs.map((document) {
                          return buildEventListItem(
                            title: document['title'],
                            date: document['date'],
                            status: document['status'],
                            priority: document['priority'],
                            isClosed: document['isClosed'],
                            des: document['des'],
                            type: document['type'],
                            id: document['id'],
                            question: document['question'],
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

  ///New Event Prompt
  Widget buildNewEventPrompt() {
    print('buildNewEventPrompt');
    buildNewEventPage1() {
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
                  controller: eventTitleController,
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
                  controller: eventDescriptionController,
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
                // Container(
                //   height: 50,
                //   width: 200,
                //   margin: EdgeInsets.only(top: 15),
                //   child: DropdownButton<String>(
                //     value: selectedEventType,
                //     icon: const Icon(Icons.arrow_drop_down),
                //     iconSize: 20,
                //     elevation: 16,
                //     isExpanded: true,
                //     style:
                //         GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                //     underline: Container(
                //       height: 1.5,
                //       width: 300,
                //       color: Colors.black87,
                //     ),
                //     onChanged: (String newValue) {
                //       setState(() {
                //         selectedEventType = newValue;
                //       });
                //     },
                //     items: <String>['Radio / Options', 'Slider', 'Text Area']
                //         .map<DropdownMenuItem<String>>((String value) {
                //       return DropdownMenuItem<String>(
                //         value: value,
                //         child: Text(value),
                //       );
                //     }).toList(),
                //   ),
                // ),

                ///Priority
                Container(
                  height: 50,
                  width: 200,
                  margin: EdgeInsets.only(top: 20),
                  child: DropdownButton<String>(
                    value: selectedPriyority,
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
                        selectedPriyority = newValue;
                      });
                    },
                    items: <String>['High', 'Medium', 'Low']
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

    buildNewEventPage2() {
      return Column(
        children: [
          Container(
            width: 700,
            padding: EdgeInsets.only(top: 50),
            child: TextField(
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              controller: eventQuestionController,
              maxLength: 300,
              decoration: InputDecoration(
                hintText: 'Question',
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
      );
    }

    showDialoge() {
      setState(() {
        _showEventConformDialoge = true;
      });
    }

    onContinue() {
      if (_showEventPage1) {
        setState(() {
          _showEventPage1 = false;
          _showEventPage2 = true;
        });
      } else {
        showDialoge();
      }
    }

    submitEvent() async {
      event.title = eventTitleController.text;
      event.des = eventDescriptionController.text;
      // event.type = selectedEventType;
      event.priority = (selectedPriyority == 'Low')
          ? 1
          : (selectedPriyority == 'Medium')
              ? 2
              : 3;
      event.question = eventQuestionController.text;
      setState(() {
        _showSuccess = true;
      });
      await FirebaseService.addEvent(event);

      eventTitleController.text = '';
      eventDescriptionController.text = '';
      eventQuestionController.text = '';

      setState(() {
        _showEventConformDialoge = false;
        _showEventPage2 = false;
        _showEventPage1 = true;
        _takeNewEvent = false;
        _showSuccess = false;
      });
    }

    buildEventConformDialoge() {
      return Container(
        width: 1000,
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: Colors.white70,
        ),
        child: Center(
          child: Container(
            height: 200,
            width: 450,
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
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Are you sure ?',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(
                    'Your new event will be published.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CustomButton(
                        text: 'Cancel',
                        bgColor: AppColor.white,
                        textColor: Colors.black,
                        onTap: () {
                          setState(() {
                            _showEventConformDialoge = false;
                          });
                        },
                      ),
                      CustomButton(
                        text: 'Submit',
                        onTap: () {
                          submitEvent();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      color: Colors.white70,
      child: Center(
        child: Stack(
          children: [
            Container(
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
                    if (_showEventPage1) buildNewEventPage1(),
                    if (_showEventPage2) buildNewEventPage2(),
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
                                  _showEventPage2 = false;
                                  _showEventPage1 = true;
                                });
                              }),
                          CustomButton(
                              text: 'Continue',
                              onTap: () {
                                onContinue();
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (_showEventConformDialoge) buildEventConformDialoge(),
          ],
        ),
      ),
    );
  }

  ///New Poll Prompt
  Widget buildNewPollPrompt() {
    print('buildNewPollPrompt');
    buildNewPollPage1() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Add a new Poll
              Text(
                'Add a new Poll',
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
                  controller: pollTitleController,
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
                  controller: pollDescriptionController,
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
                // Container(
                //   height: 50,
                //   width: 200,
                //   margin: EdgeInsets.only(top: 15),
                //   child: DropdownButton<String>(
                //     value: selectedEventType,
                //     icon: const Icon(Icons.arrow_drop_down),
                //     iconSize: 20,
                //     elevation: 16,
                //     isExpanded: true,
                //     style:
                //         GoogleFonts.poppins(color: Colors.black, fontSize: 16),
                //     underline: Container(
                //       height: 1.5,
                //       width: 300,
                //       color: Colors.black87,
                //     ),
                //     onChanged: (String newValue) {
                //       setState(() {
                //         selectedEventType = newValue;
                //       });
                //     },
                //     items: <String>['Radio / Options', 'Slider', 'Text Area']
                //         .map<DropdownMenuItem<String>>((String value) {
                //       return DropdownMenuItem<String>(
                //         value: value,
                //         child: Text(value),
                //       );
                //     }).toList(),
                //   ),
                // ),

                ///Priority
                Container(
                  height: 50,
                  width: 200,
                  margin: EdgeInsets.only(top: 20),
                  child: DropdownButton<String>(
                    value: selectedPriyority,
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
                        selectedPriyority = newValue;
                      });
                    },
                    items: <String>['High', 'Medium', 'Low']
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

    buildNewPollPage2() {
      return Column(
        children: [
          Container(
            width: 700,
            padding: EdgeInsets.only(top: 50),
            child: TextField(
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              controller: pollQuestionController,
              maxLength: 300,
              decoration: InputDecoration(
                hintText: 'Question',
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
          Container(
            width: 700,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 200,
                  padding: EdgeInsets.only(top: 50),
                  child: TextField(
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    controller: pollTotalPartiesController,
                    decoration: InputDecoration(
                      hintText: 'Total no. of polls',
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
                Container(
                  width: 400,
                  padding: EdgeInsets.only(top: 50),
                  child: TextField(
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    controller: pollPartyNamesController,
                    decoration: InputDecoration(
                      hintText: 'Poll party names (Comma separated)',
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
          ),
        ],
      );
    }

    showDialoge() {
      setState(() {
        _showPollConformDialoge = true;
      });
    }

    onContinue() {
      if (_showPollPage1) {
        setState(() {
          _showPollPage1 = false;
          _showPollPage2 = true;
        });
      } else {
        showDialoge();
      }
    }

    submitPoll() async {
      poll.title = pollTitleController.text;
      poll.des = pollDescriptionController.text;
      // event.type = selectedEventType;
      poll.priority = (selectedPriyority == 'Low')
          ? 1
          : (selectedPriyority == 'Medium')
              ? 2
              : 3;
      poll.question = pollQuestionController.text;
      setState(() {
        _showSuccess = true;
      });
      await FirebaseService.addPoll(poll);

      pollTitleController.text = '';
      pollDescriptionController.text = '';
      pollQuestionController.text = '';

      setState(() {
        _showPollConformDialoge = false;
        _showPollPage2 = false;
        _showPollPage1 = true;
        _takeNewPoll = false;
        _showSuccess = false;
      });
    }

    buildPollConformDialoge() {
      return Container(
        width: 1000,
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: Colors.white70,
        ),
        child: Center(
          child: Container(
            height: 200,
            width: 450,
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
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Are you sure ?',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(
                    'Your new poll will be published.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CustomButton(
                        text: 'Cancel',
                        bgColor: AppColor.white,
                        textColor: Colors.black,
                        onTap: () {
                          setState(() {
                            _showPollConformDialoge = false;
                          });
                        },
                      ),
                      CustomButton(
                        text: 'Submit',
                        onTap: () {
                          submitPoll();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      color: Colors.white70,
      child: Center(
        child: Stack(
          children: [
            Container(
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
                    if (_showPollPage1) buildNewPollPage1(),
                    if (_showPollPage2) buildNewPollPage2(),
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
                                  _takeNewPoll = false;
                                  _showPollPage2 = false;
                                  _showPollPage1 = true;
                                });
                              }),
                          CustomButton(
                              text: 'Continue',
                              onTap: () {
                                onContinue();
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (_showPollConformDialoge) buildPollConformDialoge(),
          ],
        ),
      ),
    );
  }

  ///New User Prompt
  Widget buildUserEventPrompt() {
    print('buildUserEventPrompt');
    buildUserPromptPage1() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Title
          Text(
            _currentEvent.title,
            textAlign: TextAlign.left,
            style: GoogleFonts.mulish(
              color: Color.fromRGBO(37, 39, 51, 1),
              fontSize: 19,
              letterSpacing: 0.4000000059604645,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),

          ///Description
          Padding(
            padding: const EdgeInsets.only(top: 38.0, bottom: 40),
            child: Text(
              _currentEvent.des,
              textAlign: TextAlign.left,
              style: GoogleFonts.mulish(
                color: AppColor.text.grey,
                fontSize: 16,
                letterSpacing: 0.4000000059604645,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),

          ///Question
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Text(
                _currentEvent.question,
                textAlign: TextAlign.left,
                style: GoogleFonts.mulish(
                  color: AppColor.text.black,
                  fontSize: 27,
                  letterSpacing: 0.4000000059604645,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
          ),

          ///Title Textfield
          // Container(
          //   width: 500,
          //   padding: EdgeInsets.only(top: 50),
          //   child: TextField(
          //     style: GoogleFonts.poppins(
          //       textStyle: TextStyle(
          //         color: Colors.black,
          //       ),
          //     ),
          //     controller: eventTitleController,
          //     maxLength: 100,
          //     decoration: InputDecoration(
          //       hintText: 'Name',
          //       hintStyle: GoogleFonts.poppins(
          //         textStyle: TextStyle(
          //           color: Colors.black,
          //         ),
          //       ),
          //       disabledBorder: UnderlineInputBorder(
          //         borderSide: BorderSide(color: Colors.black87),
          //       ),
          //       enabledBorder: UnderlineInputBorder(
          //         borderSide: BorderSide(color: Colors.black),
          //       ),
          //       focusedBorder: UnderlineInputBorder(
          //         borderSide: BorderSide(color: Colors.black),
          //       ),
          //       border: UnderlineInputBorder(
          //         borderSide: BorderSide(color: Colors.black),
          //       ),
          //     ),
          //   ),
          // ),

          ///Answer Box
          Center(
            child: Container(
              width: 700,
              height: 200,
              padding: EdgeInsets.only(top: 50),
              child: TextField(
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                controller: eventAnswerController,
                minLines: 1,
                maxLines: 20,
                maxLength: 1000,
                decoration: InputDecoration(
                  hintText: 'Answer',
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
          ),
        ],
      );
    }

    buildAnswerConformDialoge() {
      print('buildAnswerConformDialoge');
      return Container(
        width: 1000,
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: Colors.white70,
        ),
        child: Center(
          child: Container(
            height: 200,
            width: 450,
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
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Are you sure ?',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(
                    'Your new answer will be published.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CustomButton(
                        text: 'Cancel',
                        bgColor: AppColor.white,
                        textColor: Colors.black,
                        onTap: () {
                          setState(() {
                            _showAnswerConformDialoge = false;
                          });
                        },
                      ),
                      CustomButton(
                          text: 'Submit',
                          onTap: () async {
                            print('User answer submit');
                            setState(() {
                              _showSuccess = true;
                            });
                            await FirebaseFirestore.instance
                                .runTransaction((transaction) async {
                              var dbData =
                                  await DataSchemas.eventsSubmissionCount.get();
                              var count = dbData.data()['count'];
                              count++;
                              await DataSchemas.eventSubmissions
                                  .doc(count.toString())
                                  .set({
                                'id': _currentEvent.id,
                                'userId': FirebaseAuthentication.getUserID(),
                                'email': FirebaseAuthentication.getUserEmail(),
                                'answer': eventAnswerController.text,
                              });
                              await DataSchemas.eventsSubmissionCount.set({
                                'count': count,
                              });
                            }).catchError((e) {
                              print(e);
                            });
                            setState(() {
                              _showSuccess = false;
                              _showAnswerConformDialoge = false;
                              _takeUserResponse = false;
                            });
                            print('User answer submit');
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      color: Colors.white70,
      child: Center(
        child: Stack(
          children: [
            Container(
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
                    buildUserPromptPage1(),
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
                                  _takeUserResponse = false;
                                });
                              }),
                          CustomButton(
                              text: 'Submit',
                              onTap: () {
                                setState(() {
                                  _showAnswerConformDialoge = true;
                                });
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (_showAnswerConformDialoge) buildAnswerConformDialoge(),
          ],
        ),
      ),
    );
  }

  ///Export
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
                value: selectedExportEvent,
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
                    selectedExportEvent = newValue;
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

  ///Insights
  Widget buildInsightsContent() {
    return Column(
      children: [
        WebBar(
          title: 'Insights',
        ),
      ],
    );
  }

  ///WIDGETS Need Response Events
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
                      return buildEventListItem(
                        title: document['title'],
                        date: document['date'],
                        status: document['status'],
                        priority: document['priority'],
                        isClosed: document['isClosed'],
                        des: document['des'],
                        type: document['type'],
                        id: document['id'],
                        question: document['question'],
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

  ///WIDGETS Active Events
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
                      return buildEventListItem(
                        title: document['title'],
                        date: document['date'],
                        status: document['status'],
                        priority: document['priority'],
                        isClosed: document['isClosed'],
                        des: document['des'],
                        type: document['type'],
                        id: document['id'],
                        question: document['question'],
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

  ///WIDGETS Closed Events
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
                      return buildEventListItem(
                        title: document['title'],
                        date: document['date'],
                        status: document['status'],
                        priority: document['priority'],
                        isClosed: document['isClosed'],
                        des: document['des'],
                        type: document['type'],
                        id: document['id'],
                        question: document['question'],
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

  ///WIDGETS Closed Events
  // Widget buildOnHoldEvents() {
  //   return Center(
  //     child: Container(
  //       width: 1000,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(8),
  //         ),
  //         color: Color.fromRGBO(255, 255, 255, 1),
  //         border: Border.all(
  //           color: Color.fromRGBO(223, 224, 235, 1),
  //           width: 1,
  //         ),
  //       ),
  //       margin: EdgeInsets.only(top: 50),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(
  //               top: 40,
  //               left: 40,
  //               bottom: 40,
  //             ),
  //             child: Text(
  //               'On Hold',
  //               textAlign: TextAlign.left,
  //               style: GoogleFonts.mulish(
  //                 color: Color.fromRGBO(37, 39, 51, 1),
  //                 fontSize: 19,
  //                 letterSpacing: 0.4000000059604645,
  //                 fontWeight: FontWeight.bold,
  //                 height: 1,
  //               ),
  //             ),
  //           ),
  //           buildEventListItem(
  //             title: 'Online LMS Feedback',
  //             date: '23 May 2020',
  //           ),
  //           buildEventListItem(
  //             title: 'Online LMS Feedback',
  //             date: '23 May 2020',
  //           ),
  //           buildEventListItem(
  //             title: 'Online LMS Feedback',
  //             date: '23 May 2020',
  //           ),
  //           buildEventListItem(
  //             title: 'Online LMS Feedback',
  //             date: '23 May 2020',
  //           ),
  //           buildEventListItem(
  //             title: 'Online LMS Feedback',
  //             date: '23 May 2020',
  //           ),
  //           buildEventListItem(
  //             title: 'Online LMS Feedback',
  //             date: '23 May 2020',
  //           ),
  //           buildEventListItem(
  //             title: 'Online LMS Feedback',
  //             date: '23 May 2020',
  //           ),
  //           buildEventListItem(
  //             title: 'Online LMS Feedback',
  //             date: '23 May 2020',
  //           ),
  //           buildEventListItem(
  //             title: 'Online LMS Feedback',
  //             date: '23 May 2020',
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  ///WIDGETS SideBar
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
                _createPollsSelected = false;
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
          // MenuItem(
          //   text: 'History',
          //   icon: Icons.history,
          //   isSelected: _historySelected,
          //   onTap: () {
          //     setState(() {
          //       _eventsSelected = false;
          //       _historySelected = true;
          //       _settingsSelected = false;
          //       _createEventsSelected = false;
          //       _createNotificationSelected = false;
          //       _createGroupSelected = false;
          //       _insightsSelected = false;
          //       _exportDataSelected = false;
          //     });
          //   },
          // ),

          ///Insights
          MenuItem(
            text: 'Insights',
            icon: Icons.bar_chart,
            isSelected: _insightsSelected,
            onTap: () {
              setState(() {
                _createPollsSelected = false;
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
                _createPollsSelected = false;
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

          ///Manage Poll
          MenuItem(
            text: 'Manage Polls',
            icon: Icons.add,
            isSelected: _createPollsSelected,
            onTap: () {
              setState(() {
                _createEventsSelected = false;
                _createPollsSelected = true;
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
          // MenuItem(
          //   text: 'Manage Groups',
          //   icon: Icons.group_add,
          //   isSelected: _createGroupSelected,
          //   onTap: () {
          //     setState(() {
          //       _createGroupSelected = true;
          //       _createNotificationSelected = false;
          //       _createEventsSelected = false;
          //       _eventsSelected = false;
          //       _historySelected = false;
          //       _settingsSelected = false;
          //       _exportDataSelected = false;
          //       _insightsSelected = false;
          //     });
          //   },
          // ),

          ///Create Notifications
          // MenuItem(
          //   text: 'Create Notifications',
          //   icon: Icons.add_alert,
          //   isSelected: _createNotificationSelected,
          //   onTap: () {
          //     setState(() {
          //       _createNotificationSelected = true;
          //       _createEventsSelected = false;
          //       _eventsSelected = false;
          //       _historySelected = false;
          //       _settingsSelected = false;
          //       _createGroupSelected = false;
          //       _insightsSelected = false;
          //       _exportDataSelected = false;
          //     });
          //   },
          // ),

          ///Export Data
          MenuItem(
            text: 'Export Data',
            icon: Icons.download_rounded,
            isSelected: _exportDataSelected,
            onTap: () {
              setState(() {
                _createPollsSelected = false;
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

          /// Divider
          Container(
            width: 240,
            height: 1,
            margin: EdgeInsets.symmetric(vertical: 10),
            color: AppColor.text.grey.withOpacity(0.2),
          ),

          ///settings
          MenuItem(
            text: 'Settings',
            icon: Icons.settings,
            isSelected: _settingsSelected,
            onTap: () {
              setState(() {
                _createPollsSelected = false;
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

  ///WIDGETS EventListItem
  Widget buildEventListItem({
    @required String title,
    @required String date,
    int status = 0,
    int priority = 0,
    bool isClosed = false,
    @required int id,
    @required String des,
    @required String type,
    @required String question,
  }) {
    return InkWell(
      onTap: () {
        print('isAdmin $isAdmin');
        if (!isAdmin && !isClosed) {
          print('isAdmin $isAdmin');
          setState(() {
            _currentEvent = Event(
              id: id,
              title: title,
              des: des,
              date: date,
              type: type,
              question: question,
              status: status,
              priority: priority,
              isClosed: isClosed,
            );
            _takeUserResponse = true;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 50,
          right: 50,
          bottom: 20,
          top: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // if (!isAdmin)
                //   if (status == 1)
                //     Container(
                //       height: 20,
                //       width: 20,
                //       margin: EdgeInsets.only(right: 20),
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         border: Border.all(
                //           color: AppColor.text.grey,
                //           width: 2,
                //         ),
                //       ),
                //       child: Center(
                //         child: Icon(
                //           Icons.check,
                //           color: AppColor.white,
                //           size: 15,
                //         ),
                //       ),
                //     )
                //   else if (status == 2)
                //     Container(
                //       height: 20,
                //       width: 20,
                //       margin: EdgeInsets.only(right: 20),
                //       decoration: BoxDecoration(
                //         color: AppColor.border.blue,
                //         shape: BoxShape.circle,
                //       ),
                //       child: Center(
                //         child: Icon(
                //           Icons.check,
                //           color: AppColor.white,
                //           size: 15,
                //         ),
                //       ),
                //     )
                //   else
                //     Container(
                //       height: 20,
                //       width: 20,
                //     ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.mulish(
                        color: Color.fromRGBO(37, 39, 51, 1),
                        fontSize: 14,
                        letterSpacing: 0.20000000298023224,
                        fontWeight: FontWeight.normal,
                        height: 1.4285714285714286),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (isClosed)
                  Container(
                    height: 20,
                    width: 50,
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.redAccent,
                    ),
                    child: Center(
                      child: Text(
                        'Closed',
                        style: GoogleFonts.mulish(
                          color: AppColor.text.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 20,
                    width: 50,
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text(
                        'Open',
                        style: GoogleFonts.mulish(
                          color: AppColor.text.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                if (priority == 3)
                  Container(
                    height: 20,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.redAccent,
                    ),
                    child: Center(
                      child: Text(
                        'HIGH',
                        style: GoogleFonts.mulish(
                          color: AppColor.text.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  )
                else if (priority == 2)
                  Container(
                    height: 20,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.orangeAccent,
                    ),
                    child: Center(
                      child: Text(
                        'MEDIUM',
                        style: GoogleFonts.mulish(
                          color: AppColor.text.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  )
                else if (priority == 1)
                  Container(
                    height: 20,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text(
                        'LOW',
                        style: GoogleFonts.mulish(
                          color: AppColor.text.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  date,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.mulish(
                      color: AppColor.text.grey,
                      fontSize: 14,
                      letterSpacing: 0.20000000298023224,
                      fontWeight: FontWeight.normal,
                      height: 1.4285714285714286),
                ),
                if (isAdmin)
                  DropdownButton(
                    icon: Icon(Icons.more_vert),
                    underline: Container(
                      width: 10,
                    ),
                    items: <String>[
                      'Open',
                      'Close',
                      'Delete',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                        onTap: () {},
                      );
                    }).toList(),
                    onTap: () {
                      print('Tapped');
                    },
                    onChanged: (value) {
                      print(value);
                      if (value == 'Open') {
                        DataSchemas.events.doc(id.toString()).set({
                          'isClosed': false,
                        }, SetOptions(merge: true));
                      } else if (value == 'Close') {
                        ///update db to close
                        DataSchemas.events.doc(id.toString()).set({
                          'isClosed': true,
                        }, SetOptions(merge: true));
                      } else if (value == 'Delete') {
                        DataSchemas.events.doc(id.toString()).delete();
                      }
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///WIDGETS PollListItem
  Widget buildPollListItem({
    @required String title,
    @required String date,
    int status = 0,
    int priority = 0,
    bool isClosed = false,
    @required int id,
    @required String des,
    @required String type,
    @required String question,
  }) {
    return InkWell(
      onTap: () {
        print('isAdmin $isAdmin');
        if (!isAdmin && !isClosed) {
          print('isAdmin $isAdmin');
          setState(() {
            _currentEvent = Event(
              id: id,
              title: title,
              des: des,
              date: date,
              type: type,
              question: question,
              status: status,
              priority: priority,
              isClosed: isClosed,
            );
            _takeUserResponse = true;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 50,
          right: 50,
          bottom: 20,
          top: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // if (!isAdmin)
                //   if (status == 1)
                //     Container(
                //       height: 20,
                //       width: 20,
                //       margin: EdgeInsets.only(right: 20),
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         border: Border.all(
                //           color: AppColor.text.grey,
                //           width: 2,
                //         ),
                //       ),
                //       child: Center(
                //         child: Icon(
                //           Icons.check,
                //           color: AppColor.white,
                //           size: 15,
                //         ),
                //       ),
                //     )
                //   else if (status == 2)
                //     Container(
                //       height: 20,
                //       width: 20,
                //       margin: EdgeInsets.only(right: 20),
                //       decoration: BoxDecoration(
                //         color: AppColor.border.blue,
                //         shape: BoxShape.circle,
                //       ),
                //       child: Center(
                //         child: Icon(
                //           Icons.check,
                //           color: AppColor.white,
                //           size: 15,
                //         ),
                //       ),
                //     )
                //   else
                //     Container(
                //       height: 20,
                //       width: 20,
                //     ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.mulish(
                        color: Color.fromRGBO(37, 39, 51, 1),
                        fontSize: 14,
                        letterSpacing: 0.20000000298023224,
                        fontWeight: FontWeight.normal,
                        height: 1.4285714285714286),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (isClosed)
                  Container(
                    height: 20,
                    width: 50,
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.redAccent,
                    ),
                    child: Center(
                      child: Text(
                        'Closed',
                        style: GoogleFonts.mulish(
                          color: AppColor.text.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 20,
                    width: 50,
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text(
                        'Open',
                        style: GoogleFonts.mulish(
                          color: AppColor.text.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                if (priority == 3)
                  Container(
                    height: 20,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.redAccent,
                    ),
                    child: Center(
                      child: Text(
                        'HIGH',
                        style: GoogleFonts.mulish(
                          color: AppColor.text.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  )
                else if (priority == 2)
                  Container(
                    height: 20,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.orangeAccent,
                    ),
                    child: Center(
                      child: Text(
                        'MEDIUM',
                        style: GoogleFonts.mulish(
                          color: AppColor.text.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  )
                else if (priority == 1)
                  Container(
                    height: 20,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text(
                        'LOW',
                        style: GoogleFonts.mulish(
                          color: AppColor.text.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  date,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.mulish(
                      color: AppColor.text.grey,
                      fontSize: 14,
                      letterSpacing: 0.20000000298023224,
                      fontWeight: FontWeight.normal,
                      height: 1.4285714285714286),
                ),
                if (isAdmin)
                  DropdownButton(
                    icon: Icon(Icons.more_vert),
                    underline: Container(
                      width: 10,
                    ),
                    items: <String>[
                      'Open',
                      'Close',
                      'Delete',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                        onTap: () {},
                      );
                    }).toList(),
                    onTap: () {
                      print('Tapped');
                    },
                    onChanged: (value) {
                      print(value);
                      if (value == 'Open') {
                        DataSchemas.events.doc(id.toString()).set({
                          'isClosed': false,
                        }, SetOptions(merge: true));
                      } else if (value == 'Close') {
                        ///update db to close
                        DataSchemas.events.doc(id.toString()).set({
                          'isClosed': true,
                        }, SetOptions(merge: true));
                      } else if (value == 'Delete') {
                        DataSchemas.events.doc(id.toString()).delete();
                      }
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///================================================Bussiness Logic
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
