import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool _showLogout = false;
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
  bool _eventsSelected = !isAdmin;
  bool _pollsSelected = false;
  bool _settingsSelected = false;
  bool _createEventsSelected = false;
  bool _createPollsSelected = false;
  bool _createNotificationSelected = false;
  bool _createGroupSelected = false;
  bool _exportDataSelected = false;
  bool _insightsSelected = isAdmin;

  ///Add a new Poll
  bool _takeNewPoll = false;

  final TextEditingController pollTitleController = TextEditingController();
  final TextEditingController pollDescriptionController =
      TextEditingController();
  final TextEditingController pollQuestionController = TextEditingController();
  // final TextEditingController pollPartyNamesController =
  //     TextEditingController();
  // final TextEditingController pollTotalPartiesController =
  //     TextEditingController();
  bool _showPollConformDialoge = false;
  bool _takeUserResponsePoll = false;

  bool _showPollPage1 = true;
  bool _showPollPage2 = false;
  Poll poll = Poll();
  Poll _currentPoll = Poll();

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
  bool _takeUserResponseEvent = false;
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
  ///Events
  bool _activeEvents = false;
  bool _needResponse = true;
  bool _closedEvents = false;
  bool _onHoldEvents = false;

  String activeEventsCount = null;
  String needResponseCount = null;
  String closedEventsCount = null;
  String onHoldEventsCount = null;

  ///Polls
  bool _activePolls = false;
  bool _needResponsePolls = true;
  bool _closedPolls = false;
  bool _onHoldPolls = false;

  String activePollsCount = null;
  String needResponsePollsCount = null;
  String closedPollsCount = null;
  String onHoldPollsCount = null;

  String _pollAnswer = null;

  ///Insights
  String allEventsCount = null;
  bool insightsEvents = true;
  bool insightsPolls = false;
  bool _showInsightsEventResults = false;
  bool _showInsightsPollsResults = false;
  String allPollsCount = null;
  String insightsSelectedEvent = null;
  final TextEditingController insightsNameController = TextEditingController();
  var pollResultWidgets = [];
  @override
  void initState() {
    //TODO:: REMOVE PLZ
    // isAdmin = true;
    // TODO: implement initState
    super.initState();
    getInitialData();
  }

  void getInitialData() async {
    print('start');

    ///active events
    DataGets.activeEvents.then((value) {
      setState(() {
        activeEventsCount = value.docs.length.toString();
      });
    });

    ///need response
    DataGets.needResponse.then((value) {
      setState(() {
        needResponseCount = value.docs.length.toString();
      });
    });

    ///closed events
    DataGets.closedEvents.then((value) {
      setState(() {
        closedEventsCount = value.docs.length.toString();
      });
    });

    ///active polls
    DataGets.activePolls.then((value) {
      setState(() {
        activePollsCount = value.docs.length.toString();
      });
    });

    ///need response
    DataGets.needResponsePolls.then((value) {
      setState(() {
        needResponsePollsCount = value.docs.length.toString();
      });
    });

    ///closed events
    DataGets.closedPolls.then((value) {
      setState(() {
        closedPollsCount = value.docs.length.toString();
      });
    });

    ///All events
    DataGets.events.then((value) {
      setState(() {
        allEventsCount = value.docs.length.toString();
        print(allEventsCount);
      });
    });

    ///All polls
    DataGets.polls.then((value) {
      setState(() {
        allPollsCount = value.docs.length.toString();
        print(allPollsCount);
      });
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
                      if (_pollsSelected) buildPollsContent(),
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

          if (_takeUserResponseEvent) buildUserEventPrompt(),

          if (_takeUserResponsePoll) buildUserPollPrompt(),

          ///Loading animation
          if (_showLoading) LoadingAnimation(),

          if (_showLogout) buildLogoutContent(),

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
        buildWebBar(
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
          buildWebBar(
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

  ///Polls
  Widget buildPollsContent() {
    return Container(
      child: Column(
        children: [
          buildWebBar(
            title: 'Polls',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CountCards(
                title: 'Active Polls',
                count: activePollsCount ?? '-',
                selected: _activePolls,
                onTap: () {
                  setState(() {
                    _activePolls = true;
                    _needResponsePolls = false;
                    _closedPolls = false;
                    _onHoldPolls = false;
                  });
                },
              ),
              CountCards(
                title: 'Need Response',
                count: needResponsePollsCount ?? '-',
                selected: _needResponsePolls,
                onTap: () {
                  setState(() {
                    _activePolls = false;
                    _needResponsePolls = true;
                    _closedPolls = false;
                    _onHoldPolls = false;
                  });
                },
              ),
              CountCards(
                title: 'Closed Polls',
                count: closedPollsCount ?? '-',
                selected: _closedPolls,
                onTap: () {
                  setState(() {
                    _activePolls = false;
                    _needResponsePolls = false;
                    _closedPolls = true;
                    _onHoldPolls = false;
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
          if (_activePolls) buildActivePolls(),
          if (_needResponsePolls) buildNeedResponsePolls(),
          if (_closedPolls) buildClosedPolls(),
          // if (_onHoldEvents) buildOnHoldEvents(),
        ],
      ),
    );
  }

  ///Manage Polls
  Widget buildCreatePollsContent() {
    return Column(
      children: [
        buildWebBar(
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
                    stream: DataStreams.polls,
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

  ///Manage Events
  Widget buildCreateEventsContent() {
    return Column(
      children: [
        buildWebBar(
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
                hintText: 'Enter parties (Comma separated)',
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
          // Container(
          //   width: 700,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       Container(
          //         width: 200,
          //         padding: EdgeInsets.only(top: 50),
          //         child: TextField(
          //           style: GoogleFonts.poppins(
          //             textStyle: TextStyle(
          //               color: Colors.black,
          //             ),
          //           ),
          //           controller: pollTotalPartiesController,
          //           decoration: InputDecoration(
          //             hintText: 'Total no. of polls',
          //             hintStyle: GoogleFonts.poppins(
          //               textStyle: TextStyle(
          //                 color: Colors.black,
          //               ),
          //             ),
          //             disabledBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.black87),
          //             ),
          //             enabledBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.black),
          //             ),
          //             focusedBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.black),
          //             ),
          //             border: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.black),
          //             ),
          //           ),
          //         ),
          //       ),
          //       Container(
          //         width: 400,
          //         padding: EdgeInsets.only(top: 50),
          //         child: TextField(
          //           style: GoogleFonts.poppins(
          //             textStyle: TextStyle(
          //               color: Colors.black,
          //             ),
          //           ),
          //           controller: pollPartyNamesController,
          //           decoration: InputDecoration(
          //             hintText: 'Poll party names (Comma separated)',
          //             hintStyle: GoogleFonts.poppins(
          //               textStyle: TextStyle(
          //                 color: Colors.black,
          //               ),
          //             ),
          //             disabledBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.black87),
          //             ),
          //             enabledBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.black),
          //             ),
          //             focusedBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.black),
          //             ),
          //             border: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.black),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
                            _showEventConformDialoge = false;
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
                                'name': _currentEvent.title,
                                'userId': FirebaseAuthentication.getUserID(),
                                'email': FirebaseAuthentication.getUserEmail(),
                                'answer': eventAnswerController.text,
                                'date': DateTime.now().toString(),
                              });
                              await DataSchemas.eventsSubmissionCount.set({
                                'count': count,
                              });
                            }).catchError((e) {
                              print(e);
                            });
                            setState(() {
                              _showSuccess = false;
                              _showEventConformDialoge = false;
                              _takeUserResponseEvent = false;
                            });
                            eventAnswerController.text = '';
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
                                  _takeUserResponseEvent = false;
                                });
                              }),
                          CustomButton(
                              text: 'Submit',
                              onTap: () {
                                setState(() {
                                  _showEventConformDialoge = true;
                                });
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (_showEventConformDialoge) buildAnswerConformDialoge(),
          ],
        ),
      ),
    );
  }

  ///New User Prompt
  Widget buildUserPollPrompt() {
    print('buildUserPollPrompt');
    buildUserPromptPage1() {
      var list = _currentPoll.question.split(',');
      var radioList = [];
      for (int i = 0; i < list.length; i++) {
        radioList.add(RadioListTile(
            value: list[i],
            title: Text(list[i]),
            groupValue: _pollAnswer,
            onChanged: (value) {
              setState(() {
                _pollAnswer = value;
              });
              eventAnswerController.text = value;
            }));
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Title
          Text(
            _currentPoll.title,
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
              _currentPoll.des,
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
          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 38.0),
          //     child: Text(
          //       _currentPoll.question,
          //       textAlign: TextAlign.left,
          //       style: GoogleFonts.mulish(
          //         color: AppColor.text.black,
          //         fontSize: 27,
          //         letterSpacing: 0.4000000059604645,
          //         fontWeight: FontWeight.bold,
          //         height: 1,
          //       ),
          //     ),
          //   ),
          // ),

          Container(
            width: 1000,
            height: 270,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...radioList,
                  ],
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

          //TODO:: work left

          //TODO:: check this
          ///Answer Box
          // Center(
          //   child: Container(
          //     width: 700,
          //     height: 200,
          //     padding: EdgeInsets.only(top: 50),
          //     child: TextField(
          //       style: GoogleFonts.poppins(
          //         textStyle: TextStyle(
          //           color: Colors.black,
          //         ),
          //       ),
          //       controller: eventAnswerController,
          //       minLines: 1,
          //       maxLines: 20,
          //       maxLength: 1000,
          //       decoration: InputDecoration(
          //         hintText: 'Answer',
          //         hintStyle: GoogleFonts.poppins(
          //           textStyle: TextStyle(
          //             color: Colors.black,
          //           ),
          //         ),
          //         disabledBorder: UnderlineInputBorder(
          //           borderSide: BorderSide(color: Colors.black87),
          //         ),
          //         enabledBorder: UnderlineInputBorder(
          //           borderSide: BorderSide(color: Colors.black),
          //         ),
          //         focusedBorder: UnderlineInputBorder(
          //           borderSide: BorderSide(color: Colors.black),
          //         ),
          //         border: UnderlineInputBorder(
          //           borderSide: BorderSide(color: Colors.black),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      );
    }

    buildPollConformDialoge() {
      print('buildPollConformDialoge');
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
                    'Your poll will be submitted.',
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
                          onTap: () async {
                            print('User poll submit');
                            setState(() {
                              _showSuccess = true;
                            });
                            await FirebaseFirestore.instance
                                .runTransaction((transaction) async {
                              print('===========');
                              var dbData =
                                  await DataSchemas.pollSubmissionCount.get();
                              print('===========');
                              var count = dbData.data()['count'];
                              count++;
                              print('===========');
                              await DataSchemas.pollSubmissions
                                  .doc(count.toString())
                                  .set({
                                'id': _currentPoll.id,
                                'name': _currentPoll.title,
                                'userId': FirebaseAuthentication.getUserID(),
                                'email': FirebaseAuthentication.getUserEmail(),
                                'answer': eventAnswerController.text,
                                'date': DateTime.now().toString(),
                              });

                              print(_currentPoll.id);
                              var res = await DataSchemas.pollResults
                                  .doc(_currentPoll.title)
                                  .get();
                              var resData = res.data();
                              print(resData);
                              var resCount =
                                  resData[eventAnswerController.text];
                              print(resCount);
                              resCount++;
                              resData[eventAnswerController.text] = resCount;
                              print(resData);
                              await DataSchemas.pollResults
                                  .doc(_currentPoll.title)
                                  .set(resData);

                              print('===========');
                              await DataSchemas.pollSubmissionCount.set({
                                'count': count,
                              });
                            }).catchError((e) {
                              print(e);
                            });
                            setState(() {
                              _showSuccess = false;
                              _showPollConformDialoge = false;
                              _takeUserResponsePoll = false;
                            });
                            eventAnswerController.text = '';
                            print('User poll submit');
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
                                  _takeUserResponsePoll = false;
                                });
                              }),
                          CustomButton(
                              text: 'Submit',
                              onTap: () {
                                setState(() {
                                  _showPollConformDialoge = true;
                                });
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

  ///Export
  Widget buildExportDataContent() {
    return Column(
      children: [
        buildWebBar(
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
        buildWebBar(
          title: 'Insights',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CountCards(
              title: 'Total Events',
              count: allEventsCount ?? '-',
              selected: insightsEvents,
              onTap: () {
                setState(() {
                  insightsEvents = true;
                  insightsPolls = false;
                });
              },
            ),
            CountCards(
              title: 'All Polls',
              count: allPollsCount ?? '-',
              selected: insightsPolls,
              onTap: () {
                setState(() {
                  insightsEvents = false;
                  insightsPolls = true;
                });
              },
            ),
          ],
        ),
        if (insightsEvents) buildInsightsEvent(),
        if (insightsPolls) buildInsightsPolls(),
      ],
    );
  }

  ///WIDGETS insights events
  Widget buildInsightsEvent() {
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
            Center(
              child: Container(
                width: 700,
                margin: EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 300,
                      padding: EdgeInsets.only(top: 50),
                      child: TextField(
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        controller: insightsNameController,
                        decoration: InputDecoration(
                          hintText: 'Event Name',
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
                    CustomButton(
                        text: 'Get Data',
                        onTap: () {
                          setState(() {
                            _showInsightsEventResults = true;
                          });
                        })
                  ],
                ),
              ),
            ),
            if (_showInsightsEventResults)
              Center(
                child: Container(
                  width: 1000,
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
                          'All Events user Response',
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
                          stream: DataStreams.eventsSubmissions(
                              insightsNameController.text),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Column(
                              children: snapshot.data.docs.map((document) {
                                return buildInsightsListItem(
                                  answer: document['answer'],
                                  date: document['date'],
                                  email: document['email'],
                                  id: document['id'],
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
        ),
      ),
    );
  }

  ///WIDGETS insights polls
  Widget buildInsightsPolls() {
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
            Center(
              child: Container(
                width: 700,
                margin: EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 300,
                      padding: EdgeInsets.only(top: 50),
                      child: TextField(
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        controller: insightsNameController,
                        decoration: InputDecoration(
                          hintText: 'Poll Name',
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
                    CustomButton(
                        text: 'Get Data',
                        onTap: () async {
                          var res = await DataSchemas.pollResults
                              .doc(insightsNameController.text)
                              .get();
                          var resData = res.data();

                          pollResultWidgets = [];
                          resData.forEach((key, value) {
                            pollResultWidgets.add(Container(
                              height: 70,
                              width: 500,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 50,
                                  right: 50,
                                  bottom: 20,
                                  top: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        key,
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.mulish(
                                            color:
                                                Color.fromRGBO(37, 39, 51, 1),
                                            fontSize: 14,
                                            letterSpacing: 0.20000000298023224,
                                            fontWeight: FontWeight.normal,
                                            height: 1.4285714285714286),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        value.toString(),
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.mulish(
                                            color:
                                                Color.fromRGBO(37, 39, 51, 1),
                                            fontSize: 14,
                                            letterSpacing: 0.20000000298023224,
                                            fontWeight: FontWeight.normal,
                                            height: 1.4285714285714286),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                          });

                          setState(() {
                            _showInsightsPollsResults = true;
                          });
                        })
                  ],
                ),
              ),
            ),
            if (_showInsightsPollsResults)
              Center(
                child: Container(
                  width: 1000,
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
                          'All user Response',
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
                      // FutureBuilder(
                      //     future: DataStreams.pollSubmissions(
                      //         insightsNameController.text),
                      //     builder: (BuildContext context,
                      //         AsyncSnapshot<QuerySnapshot> snapshot) {
                      //       if (!snapshot.hasData) {
                      //         return Center(
                      //           child: CircularProgressIndicator(),
                      //         );
                      //       }
                      //       return Column(
                      //         children: snapshot.data.docs.map((document) {
                      //           return buildInsightsListItem(
                      //             date: document['date'],
                      //             id: document['id'],
                      //             answer: document['answer'],
                      //             email: document['email'],
                      //           );
                      //         }).toList(),
                      //       );
                      //     }),
                      ...pollResultWidgets,
                      Container(
                        height: 100,
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
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
                'Need an Immediate Response',
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

  ///
  /// ===================================================
  ///

  ///WIDGETS Need Response Polls
  Widget buildNeedResponsePolls() {
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
                'Need an Immediate Response',
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
                stream: DataStreams.needResponsePolls,
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
    );
  }

  ///WIDGETS Active Polls
  Widget buildActivePolls() {
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
            ///Active Polls
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
                left: 40,
                bottom: 40,
              ),
              child: Text(
                'Active Polls',
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
                stream: DataStreams.activePolls,
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
    );
  }

  ///WIDGETS Closed Polls
  Widget buildClosedPolls() {
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
                'Closed Polls',
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
                stream: DataStreams.closedPolls,
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
    );
  }

  Widget buildLogoutContent() {
    return GestureDetector(
      onTap: () {
        print('Pressed');
        setState(() {
          _showLogout = false;
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              right: 50,
              top: 90,
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: Colors.white,
                  border: Border.all(
                    color: Color.fromRGBO(223, 224, 235, 1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    if (!isAdmin)
                      MenuItem(
                        text: 'Account',
                        icon: Icons.person,
                        isSelected: false,
                        onTap: () {
                          setState(() {
                            _createPollsSelected = false;
                            _exportDataSelected = false;
                            _eventsSelected = false;
                            _pollsSelected = false;
                            _settingsSelected = true;
                            _createEventsSelected = false;
                            _createNotificationSelected = false;
                            _createGroupSelected = false;
                            _insightsSelected = false;
                            _showLogout = false;
                          });
                        },
                      ),
                    MenuItem(
                      text: 'Signout',
                      isSelected: false,
                      icon: Icons.logout,
                      onTap: () async {
                        setState(() {
                          _showLoading = true;
                        });
                        while (Navigator.canPop(context))
                          Navigator.pop(context);
                        Navigator.pushNamed(context, HomePage.id);
                        await FirebaseAuth.instance.signOut();
                        setState(() {
                          _showLoading = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
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
          if (!isAdmin)
            MenuItem(
              text: 'Events',
              icon: Icons.event_note,
              isSelected: _eventsSelected,
              onTap: () {
                setState(() {
                  _createPollsSelected = false;
                  _eventsSelected = true;
                  _pollsSelected = false;
                  _settingsSelected = false;
                  _createEventsSelected = false;
                  _createNotificationSelected = false;
                  _createGroupSelected = false;
                  _insightsSelected = false;
                  _exportDataSelected = false;
                });
              },
            ),

          ///Polls
          if (!isAdmin)
            MenuItem(
              text: 'Polls',
              icon: Icons.poll,
              isSelected: _pollsSelected,
              onTap: () {
                setState(() {
                  _createPollsSelected = false;
                  _eventsSelected = false;
                  _pollsSelected = true;
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
          if (isAdmin)
            MenuItem(
              text: 'Insights',
              icon: Icons.dashboard,
              isSelected: _insightsSelected,
              onTap: () {
                setState(() {
                  _createPollsSelected = false;
                  _insightsSelected = true;
                  _createGroupSelected = false;
                  _pollsSelected = false;
                  _createNotificationSelected = false;
                  _createEventsSelected = false;
                  _eventsSelected = false;
                  _pollsSelected = false;
                  _settingsSelected = false;
                  _exportDataSelected = false;
                });
              },
            ),

          ///Manage Events
          if (isAdmin)
            MenuItem(
              text: 'Manage Events',
              icon: Icons.event_note,
              isSelected: _createEventsSelected,
              onTap: () {
                setState(() {
                  _createPollsSelected = false;
                  _createEventsSelected = true;
                  _eventsSelected = false;
                  _pollsSelected = false;
                  _settingsSelected = false;
                  _createNotificationSelected = false;
                  _createGroupSelected = false;
                  _insightsSelected = false;
                  _exportDataSelected = false;
                });
              },
            ),

          ///Manage Poll
          if (isAdmin)
            MenuItem(
              text: 'Manage Polls',
              icon: Icons.poll,
              isSelected: _createPollsSelected,
              onTap: () {
                setState(() {
                  _createEventsSelected = false;
                  _createPollsSelected = true;
                  _eventsSelected = false;
                  _pollsSelected = false;
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
          // if (isAdmin)
          //   MenuItem(
          //     text: 'Export Data',
          //     icon: Icons.download_rounded,
          //     isSelected: _exportDataSelected,
          //     onTap: () {
          //       setState(() {
          //         _createPollsSelected = false;
          //         _exportDataSelected = true;
          //         _createEventsSelected = false;
          //         _eventsSelected = false;
          //         _pollsSelected = false;
          //         _settingsSelected = false;
          //         _createNotificationSelected = false;
          //         _createGroupSelected = false;
          //         _insightsSelected = false;
          //       });
          //     },
          //   ),

          /// Divider
          if (!isAdmin)
            Container(
              width: 240,
              height: 1,
              margin: EdgeInsets.symmetric(vertical: 10),
              color: AppColor.text.grey.withOpacity(0.2),
            ),

          ///settings
          if (!isAdmin)
            MenuItem(
              text: 'Settings',
              icon: Icons.settings,
              isSelected: _settingsSelected,
              onTap: () {
                setState(() {
                  _createPollsSelected = false;
                  _exportDataSelected = false;
                  _eventsSelected = false;
                  _pollsSelected = false;
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
            _takeUserResponseEvent = true;
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
            _currentPoll = Poll(
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
            _takeUserResponsePoll = true;
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
                        DataSchemas.polls.doc(id.toString()).set({
                          'isClosed': false,
                        }, SetOptions(merge: true));
                      } else if (value == 'Close') {
                        ///update db to close
                        DataSchemas.polls.doc(id.toString()).set({
                          'isClosed': true,
                        }, SetOptions(merge: true));
                      } else if (value == 'Delete') {
                        DataSchemas.polls.doc(id.toString()).delete();
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
  Widget buildInsightsListItem({
    @required String answer,
    @required String date,
    @required int id,
    @required String email,
  }) {
    return InkWell(
      onTap: () {
        // print('isAdmin $isAdmin');
        // if (!isAdmin && !isClosed) {
        //   print('isAdmin $isAdmin');
        //   setState(() {
        //     _currentPoll = Poll(
        //       id: id,
        //       title: title,
        //       des: des,
        //       date: date,
        //       type: type,
        //       question: question,
        //       status: status,
        //       priority: priority,
        //       isClosed: isClosed,
        //     );
        //     _takeUserResponsePoll = true;
        //   });
        // }
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
                    answer,
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
                // if (isClosed)
                //   Container(
                //     height: 20,
                //     width: 50,
                //     margin: EdgeInsets.only(right: 20),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(8),
                //       ),
                //       color: Colors.redAccent,
                //     ),
                //     child: Center(
                //       child: Text(
                //         'Closed',
                //         style: GoogleFonts.mulish(
                //           color: AppColor.text.white,
                //           fontSize: 10,
                //           fontWeight: FontWeight.w900,
                //         ),
                //       ),
                //     ),
                //   )
                // else
                //   Container(
                //     height: 20,
                //     width: 50,
                //     margin: EdgeInsets.only(right: 20),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(8),
                //       ),
                //       color: Colors.green,
                //     ),
                //     child: Center(
                //       child: Text(
                //         'Open',
                //         style: GoogleFonts.mulish(
                //           color: AppColor.text.white,
                //           fontSize: 10,
                //           fontWeight: FontWeight.w900,
                //         ),
                //       ),
                //     ),
                //   ),
                // if (priority == 3)
                //   Container(
                //     height: 20,
                //     width: 50,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(8),
                //       ),
                //       color: Colors.redAccent,
                //     ),
                //     child: Center(
                //       child: Text(
                //         'HIGH',
                //         style: GoogleFonts.mulish(
                //           color: AppColor.text.white,
                //           fontSize: 10,
                //           fontWeight: FontWeight.w900,
                //         ),
                //       ),
                //     ),
                //   )
                // else if (priority == 2)
                //   Container(
                //     height: 20,
                //     width: 50,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(8),
                //       ),
                //       color: Colors.orangeAccent,
                //     ),
                //     child: Center(
                //       child: Text(
                //         'MEDIUM',
                //         style: GoogleFonts.mulish(
                //           color: AppColor.text.white,
                //           fontSize: 10,
                //           fontWeight: FontWeight.w900,
                //         ),
                //       ),
                //     ),
                //   )
                // else if (priority == 1)
                //   Container(
                //     height: 20,
                //     width: 50,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(8),
                //       ),
                //       color: Colors.green,
                //     ),
                //     child: Center(
                //       child: Text(
                //         'LOW',
                //         style: GoogleFonts.mulish(
                //           color: AppColor.text.white,
                //           fontSize: 10,
                //           fontWeight: FontWeight.w900,
                //         ),
                //       ),
                //     ),
                //   ),
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
                // if (isAdmin)
                //   DropdownButton(
                //     icon: Icon(Icons.more_vert),
                //     underline: Container(
                //       width: 10,
                //     ),
                //     items: <String>[
                //       'Open',
                //       'Close',
                //       'Delete',
                //     ].map<DropdownMenuItem<String>>((String value) {
                //       return DropdownMenuItem<String>(
                //         value: value,
                //         child: Text(value),
                //         onTap: () {},
                //       );
                //     }).toList(),
                //     onTap: () {
                //       print('Tapped');
                //     },
                //     onChanged: (value) {
                //       print(value);
                //       if (value == 'Open') {
                //         DataSchemas.polls.doc(id.toString()).set({
                //           'isClosed': false,
                //         }, SetOptions(merge: true));
                //       } else if (value == 'Close') {
                //         ///update db to close
                //         DataSchemas.polls.doc(id.toString()).set({
                //           'isClosed': true,
                //         }, SetOptions(merge: true));
                //       } else if (value == 'Delete') {
                //         DataSchemas.polls.doc(id.toString()).delete();
                //       }
                //     },
                //   ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildWebBar({title}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: GoogleFonts.mulish(
                color: Color.fromRGBO(37, 39, 51, 1),
                fontSize: 24,
                letterSpacing: 0.30000001192092896,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          Row(
            children: [
              //   IconButton(
              //   icon: Icon(
              //     Icons.notifications,
              //   ),
              //   onPressed: () {},
              //   color: AppColor.text.grey,
              // ),
              // Container(
              //   height: 30,
              //   width: 1,
              //   margin: EdgeInsets.symmetric(horizontal: 20),
              //   color: AppColor.text.grey.withOpacity(0.3),
              // ),
              Text(
                FirebaseAuthentication.getUser().displayName ??
                    FirebaseAuthentication.getUser().email,
                textAlign: TextAlign.right,
                style: GoogleFonts.mulish(
                    color: AppColor.text.black,
                    fontSize: 14,
                    letterSpacing: 0.20000000298023224,
                    fontWeight: FontWeight.bold,
                    height: 1.4285714285714286),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _showLogout = true;
                  });
                },
                child: Container(
                  width: 44,
                  height: 44,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    border: Border.all(
                      color: Color.fromRGBO(223, 224, 235, 1),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.elliptical(44, 44),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      (FirebaseAuthentication.getUser().displayName ??
                              FirebaseAuthentication.getUser().email ??
                              'U')[0]
                          .toString()
                          .toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColor.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///================================================Bussiness Logic
  updateNameAndPassword() async {
    User user = FirebaseAuthentication.getUser();
    if (nameController.text != null || nameController.text.trim().isNotEmpty)
      user.updateDisplayName(nameController.text);
    if (passwordController.text != null ||
        passwordController.text.trim().isNotEmpty)
      user.updatePassword(passwordController.text);
    setState(() {
      _showSuccess = true;
    });

    await Future.delayed(Duration(seconds: 4));

    setState(() {
      _showSuccess = false;
    });
  }
}
