// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:collection';
import 'dart:convert' show json;
import 'dart:developer';
import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lunarcalendar/models/lunar_event.dart';
import 'package:lunarcalendar/ui/screens/lunar_event_screen.dart';
import 'package:lunarcalendar/utils/auth.dart';
import 'package:lunarcalendar/utils/demo_localizations.dart';
import 'package:lunarcalendar/utils/lunar_solar_converter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sorted_list/sorted_list.dart';
import 'package:uuid/uuid.dart';

// This app is a stateful, it tracks the user's current choice.
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  SortedList<LunarEvent> lunarEvents;
  ProgressDialog percentageDialog;
  static const String CALENDAR_API_URL =
      'https://www.googleapis.com/calendar/v3';
  var filePath;
  var _bannerAd;

  void _select(Choice choice) {
    switch (choice.title) {
      case 'import':
        loadCalendars().then((Map<String, String> map) {
          if (map.length == 0) {
            Fluttertoast.showToast(
              msg: DemoLocalizations.of(context)
                  .localizedValues['no_calendars_found'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text(DemoLocalizations.of(context)
                        .localizedValues['choose_a_lunar_calendar']),
                    children: map.entries.map<SimpleDialogOption>((entry) {
                      return SimpleDialogOption(
                        child: Text(entry.value),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          loadLunarEvents(entry.key);
                        },
                      );
                    }).toList(),
                  );
                });
          }
        }).catchError((e) {
          Fluttertoast.showToast(
            msg: DemoLocalizations.of(context).localizedValues['got_error'] +
                ": ${e.error}.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
        });
        break;
      case 'export':
        exportEvents().whenComplete(() {
          percentageDialog.update(progress: 0);
          percentageDialog.hide();
        });
        break;
      case 'signout':
        signOutGoogle().then((_) {
          Navigator.pushNamedAndRemoveUntil(context, "/root", (r) => false);
        });
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    lunarEvents = new SortedList((a, b) => a.compareTo(b));
    tryLoadLunarEventsFromFile();
    FirebaseAdMob.instance.initialize(appId: getAppId());
    _bannerAd = createBannerAd()
      ..load()
      ..show();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      saveToFile();
    }
  }

  void saveToFile() {
    var file = File('$filePath/lunarEvents');
    if (!file.existsSync()) {
      file.createSync();
    }
    String contents = json.encode(lunarEvents);
    file.writeAsStringSync(contents);
  }

  @override
  Widget build(BuildContext context) {
    percentageDialog =
        ProgressDialog(context, type: ProgressDialogType.Download);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(DemoLocalizations.of(context).localizedValues['title']),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              // overflow menu
              onSelected: _select,
              itemBuilder: (BuildContext _context) {
                var list = List<PopupMenuEntry<Choice>>();
                choices.asMap().forEach((index, choice) {
                  list.add(PopupMenuItem<Choice>(
                    value: choice,
                    child: ListTile(
                      leading: Icon(choice.icon),
                      title: Text(DemoLocalizations.of(context)
                          .localizedValues[choice.title]),
                    ),
                  ));
                  if (index != choices.length - 1) {
                    list.add(PopupMenuDivider(
                      height: 5,
                    ));
                  }
                });
                return list;
              },
            ),
          ],
        ),
        body: Container(
          child: _buildContent(context),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateToAddLunarEvent(context);
          },
          child: Icon(Icons.add),
        ),
      ),
      builder: (BuildContext context, Widget widget) {
        final mediaQuery = MediaQuery.of(context);
        return Padding(
          child: widget,
          padding: EdgeInsets.only(bottom: getSmartBannerHeight(mediaQuery)),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (lunarEvents.length == 0) {
      return new Center(
        child: Text(DemoLocalizations.of(context)
            .localizedValues['no_events_try_to_add_some']),
      );
    } else {
      return ListView.builder(
          itemCount: lunarEvents.length,
          itemBuilder: (_context, index) {
            final item = lunarEvents[index];
            return Card(
              child: ListTile(
                title: Text(item.summary),
                subtitle: Text(item.start +
                    ' ' +
                    DemoLocalizations.of(context).localizedValues['to'] +
                    ' ' +
                    item.end),
                trailing: MaterialButton(
                  onPressed: () {
                    lunarEvents.removeAt(index);
                    setState(() {});
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Icon(Icons.remove, size: 12),
                  padding: EdgeInsets.all(6),
                  shape: CircleBorder(),
                  height: 5,
                  minWidth: 1,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LunarEventScreen(
                                lunarEvent: lunarEvents[index],
                              )));
                },
              ),
            );
          });
    }
  }

  void _navigateToAddLunarEvent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LunarEventScreen(
                lunarEvent: new LunarEvent(),
              )),
    );
    if (null != result) {
      lunarEvents.add(result);
      setState(() {});
    }
  }

  Future<Map<String, String>> loadCalendars() async {
    percentageDialog.update(
      message:
          DemoLocalizations.of(context).localizedValues['loading_calendars'],
    );
    percentageDialog.show();
    if (googleSignIn.currentUser == null) {
      await googleSignIn.signInSilently();
    }
    final http.Response response = await http.get(
        CALENDAR_API_URL + '/users/me/calendarList',
        headers: await googleSignIn.currentUser.authHeaders);
    if (response.statusCode != 200) {
      Fluttertoast.showToast(
        msg: DemoLocalizations.of(context)
                .localizedValues['google_calendar_api_return_code'] +
            response.statusCode.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      percentageDialog.hide();
      return null;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final Map<String, String> calendarSummaryIdMap = Map.fromIterable(
        data['items'],
        key: (v) => v['id'],
        value: (v) => v['summary']);
    percentageDialog.hide();
    return calendarSummaryIdMap;
  }

  Future<void> loadLunarEvents(String calendarId) async {
    percentageDialog.update(
      message:
          DemoLocalizations.of(context).localizedValues['loading_lunar_events'],
    );
    percentageDialog.show();
    if (googleSignIn.currentUser == null) {
      await googleSignIn.signInSilently();
    }
    bool verifiedVersion = false;
    String pageToken = "";
    Set<String> idSet = HashSet();
    bool oldVersion = false;
    if (lunarEvents.length > 0) {
      idSet.addAll(lunarEvents.map<String>((lunarEvent) => lunarEvent.id));
    }
    var authHeaders = await googleSignIn.currentUser.authHeaders;
    do {
      final http.Response response = await http.get(
          CALENDAR_API_URL +
              '/calendars/$calendarId/events?orderBy=updated' +
              (pageToken.isEmpty ? "" : "&pageToken=$pageToken"),
          headers: authHeaders);
      if (response.statusCode != 200) {
        Fluttertoast.showToast(
          msg: DemoLocalizations.of(context)
                  .localizedValues['google_calendar_api_return_code'] +
              response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        percentageDialog.hide();
        return;
      }
      final Map<String, dynamic> data = json.decode(response.body);
      pageToken = data['nextPageToken'];
      var items = data['items'] as List;
      items = items.where((i) {
        if (i['start'] == null ||
            i['start']['date'] == null ||
            i['description'] == null) return false;
        return true;
      }).toList();
      items.forEach((item) {
        String description = item['description'];
        try {
          final Map<String, dynamic> jsonData = json.decode(description);
          if (!verifiedVersion) {
            if (!jsonData.containsKey('version')) {
              oldVersion = true;
            }
            verifiedVersion = true;
          }
          String id = jsonData['id'];
          if (!idSet.contains(id)) {
            if (oldVersion) {
              LunarEvent lunarEvent = getLunarEventFromOldJson(jsonData);
              idSet.add(id);
              lunarEvents.add(lunarEvent);
            } else {
              jsonData.remove('version');
              LunarEvent lunarEvent = LunarEvent.fromJson(jsonData);
              lunarEvents.add(lunarEvent);
            }
          }
        } catch (error) {
          log('Not valid json. event.description: $description');
        }
      });
    } while (pageToken?.isNotEmpty ?? false);
    percentageDialog.hide();
    setState(() {});
    return;
  }

  LunarEvent getLunarEventFromOldJson(Map<String, dynamic> jsonData) {
    LunarEvent lunarEvent = new LunarEvent(
      summary: jsonData['summary'],
      location: jsonData['location'],
      repeat: jsonData['repeat'],
      start: jsonData['start'],
      end: jsonData['end'],
      repeatType: RepeatType.values.firstWhere(
          (e) => e.toString() == 'RepeatType.' + jsonData['repeatType']),
    );
    lunarEvent.id = jsonData['id'];
    List<Reminder> reminderList = [];
    var reminders = jsonData['reminderMap'];
    if (reminders != null && reminders.length > 0) {
      (reminders as Map<String, dynamic>).forEach((key, value) {
        Reminder reminder = new Reminder(
            method: ReminderMethod.values.firstWhere((e) =>
                e.toString() ==
                'ReminderMethod.' + (value['method'] as String).toUpperCase()),
            count: value['count'],
            type:
                value['type'] == 'days' ? ReminderType.DAY : ReminderType.WEEK,
            time: value['time']);
        reminder.id = Uuid().v4();
        reminderList.add(reminder);
      });
    }
    lunarEvent.reminders = reminderList;
    return lunarEvent;
  }

  Future<void> exportEvents() async {
    if (lunarEvents.length == 0) {
      Fluttertoast.showToast(
        msg: DemoLocalizations.of(context)
            .localizedValues['no_events_to_export'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    percentageDialog.show();
    percentageDialog.update(
        message: DemoLocalizations.of(context).localizedValues['syncing'],
        progress: 0,
        maxProgress: 100.0);
    if (googleSignIn.currentUser == null) {
      await googleSignIn.signInSilently();
    }

    Map bodyData = {'summary': 'Lunar Events'};
    var body = json.encode(bodyData);
    var authHeaders = await googleSignIn.currentUser.authHeaders;
    authHeaders['Content-Type'] = 'application/json';

    http.Response response = await http.post(CALENDAR_API_URL + '/calendars',
        headers: authHeaders, body: body);
    if (response.statusCode != 200) {
      Fluttertoast.showToast(
        msg: DemoLocalizations.of(context)
                .localizedValues['google_calendar_api_return_code'] +
            response.statusCode.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      percentageDialog.hide();
      return;
    }

    final Map<String, dynamic> data = json.decode(response.body);
    String calendarId = data['id'];

    var totalEvents = 0;
    var now = DateTime.now();
    var dateFormatter = DateFormat('MM-dd');
    var timeFormatter = DateFormat('HH:mm');
    lunarEvents.forEach((e) {
      if (e.summary.isEmpty) return;
      totalEvents++;
      if (e.repeatType != RepeatType.NO_REPEAT) {
        totalEvents += e.repeat;
      }
    });

    var eventDone = 0;

    List<String> repeatBodyList = List();
    for (var e in lunarEvents) {
      if (e.summary.isEmpty) {
        continue;
      }
      var startDate = dateFormatter.parse(e.start);
      startDate = DateTime(now.year, startDate.month, startDate.day);
      var endDate = dateFormatter.parse(e.end);
      endDate = DateTime(now.year, endDate.month, endDate.day);
      var lunarStart = getLatestLunarAfterNow(now, startDate);
      var solarStart = getSolar(lunarStart, RepeatType.NO_REPEAT, 0);
      var lunarEnd = getLatestLunarAfterNow(now, endDate);
      var solarEnd = getSolar(lunarEnd, RepeatType.NO_REPEAT, 0);
      if (solarStart == null || solarEnd == null) {
        eventDone++;
        if (e.repeatType != RepeatType.NO_REPEAT) {
          eventDone += e.repeat;
        }
        publishDone(eventDone, totalEvents);
        continue;
      }
      var event = getEvent(e, solarStart, solarEnd, timeFormatter);
      var descriptionMap = e.toJson();
      descriptionMap['version'] = 2;
      event['description'] = json.encode(descriptionMap);
      body = json.encode(event);
      response = await http.post(
          CALENDAR_API_URL + '/calendars/' + calendarId + '/events',
          headers: authHeaders,
          body: body);
      eventDone++;
      publishDone(eventDone, totalEvents);
      if (e.repeatType != RepeatType.NO_REPEAT) {
        for (int x = 0; x < e.repeat; x++) {
          solarStart = getSolar(lunarStart, e.repeatType, x + 1);
          solarEnd = getSolar(lunarEnd, e.repeatType, x + 1);
          if (solarStart == null || solarEnd == null) {
            eventDone++;
            publishDone(eventDone, totalEvents);
            break;
          }
          event = getEvent(e, solarStart, solarEnd, timeFormatter);
          body = json.encode(event);
          repeatBodyList.add(body);
        }
      }
    }
    for (String body in repeatBodyList) {
      eventDone++;
      response = await http.post(
          CALENDAR_API_URL + '/calendars/' + calendarId + '/events',
          headers: authHeaders,
          body: body);
      publishDone(eventDone, totalEvents);
    }
  }

  Lunar getLatestLunarAfterNow(DateTime now, DateTime lunarDate) {
    var lunar = Lunar();
    lunar.isleap = false;
    lunar.lunarYear = now.year;
    lunar.lunarMonth = lunarDate.month;
    lunar.lunarDay = lunarDate.day;
    var solarStart = getSolar(lunar, RepeatType.NO_REPEAT, 0);
    if (solarStart == null) return null;
    var solarDate = DateTime(
        solarStart.solarYear, solarStart.solarMonth, solarStart.solarDay);
    if (solarDate.compareTo(now) < 0) {
      lunar.lunarYear++;
    }
    return lunar;
  }

  Solar getSolar(Lunar lunar, RepeatType repeatType, int offset) {
    if (lunar == null) return null;
    var lunarYear = lunar.lunarYear;
    var lunarMonth = lunar.lunarMonth;
    final newLunar = Lunar();

    if (repeatType == RepeatType.ANNUALLY) {
      lunarYear += offset;
    } else if (repeatType == RepeatType.MONTHLY) {
      lunarYear += (lunarMonth + offset - 1) ~/ 12;
      lunarMonth = (lunarMonth + offset - 1) % 12 + 1;
    }
    newLunar.isleap = lunar.isleap;
    newLunar.lunarYear = lunarYear;
    newLunar.lunarMonth = lunarMonth;
    newLunar.lunarDay = lunar.lunarDay;

    final solar = LunarSolarConverter.lunarToSolar(newLunar);
    if (solar.solarYear == -1) {
      return null;
    }
    return solar;
  }

  void publishDone(int eventDone, int totalEvents) {
    percentageDialog.update(
        progress: (eventDone * 100 / totalEvents).roundToDouble());
  }

  getEvent(LunarEvent lunarEvent, Solar solarStart, Solar solarEnd,
      DateFormat timeFormatter) {
    var reminders;
    if (lunarEvent.reminders.length > 0) {
      var overrides = [];
      for (int i = 0; i < lunarEvent.reminders.length && i <= 5; i++) {
        Reminder reminder = lunarEvent.reminders[i];
        int reminderCount = reminder.count;
        if (reminderCount == 0) continue;
        if (ReminderType.WEEK == reminder.type) {
          reminderCount *= 7;
        }
        var dayMinutes = (reminderCount - 1) * 24 * 60;
        var reminderTime = timeFormatter.parse(reminder.time);
        var startTime = timeFormatter.parse('24:00');
        var diffTime = startTime.difference(reminderTime).inMinutes.abs();
        var totalMinutes = dayMinutes + diffTime;
        // 4 weeks in minutes. 4 week is the maximum number allowed
        if (totalMinutes > 40320) continue;

        var override = {
          'method': describeEnum(reminder.method).toLowerCase(),
          'minutes': totalMinutes,
        };
        overrides.add(override);
      }
      reminders = {'useDefault': false, 'overrides': overrides};
    }

    var body = {
      'start': {
        'date':
            '${solarStart.solarYear.toString()}-${solarStart.solarMonth.toString().padLeft(2, '0')}-${solarStart.solarDay.toString().padLeft(2, '0')}',
      },
      'end': {
        'date':
            '${solarEnd.solarYear.toString()}-${solarEnd.solarMonth.toString().padLeft(2, '0')}-${solarEnd.solarDay.toString().padLeft(2, '0')}',
      },
      'summary': lunarEvent.summary,
    };
    if (lunarEvent.location?.isNotEmpty ?? false) {
      body['location'] = lunarEvent.location;
    }
    if (reminders != null) {
      body['reminders'] = reminders;
    }
    return body;
  }

  void tryLoadLunarEventsFromFile() async {
    final directory = await getApplicationDocumentsDirectory();
    filePath = directory.path;
    var file = File('$filePath/lunarEvents');
    var isFilesExists = await file.exists();
    if (isFilesExists) {
      String contents = await file.readAsString();
      if (contents?.isNotEmpty ?? false) {
        List<dynamic> list = json.decode(contents);
        for (var jsonData in list) {
          LunarEvent lunarEvent = LunarEvent.fromJson(jsonData);
          lunarEvents.add(lunarEvent);
        }
        setState(() {});
      }
    } else {
      //Try old path written by kotlin
      var path = directory.path;
      path = path.substring(0, path.lastIndexOf('/'));
      file = File('$path/files/lunarEvents');
      if (file.existsSync()) {
        String contents = await file.readAsString();
        if (contents?.isNotEmpty ?? false) {
          List<dynamic> list = json.decode(contents);
          for (var jsonData in list) {
            lunarEvents.add(getLunarEventFromOldJson(jsonData));
          }
          setState(() {});
        }
      }
    }
  }

  // You can also test with your own ad unit IDs by registering your device as a
  // test device. Check the logs for your device's ID value.
//  static const String testDevice = 'E238463BE7B0BA76C93DDE68FA93C067';
  static const String testDevice = null;

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['lunar', 'calendar', 'tool'],
    childDirected: true,
    nonPersonalizedAds: true,
  );

  static const ANDROID_APP_ID = 'ca-app-pub-4941610462008539~8138351769';
  static const IOS_APP_ID = "ca-app-pub-4941610462008539~1482088277";

  // This is test id
//  static const ANDROID_AD_UNIT_BANNER =
//      'ca-app-pub-3940256099942544/6300978111';
  static const ANDROID_AD_UNIT_BANNER =
      'ca-app-pub-4941610462008539/9544014342';
  static const IOS_AD_UNIT_BANNER = "ca-app-pub-4941610462008539/5013945654";

  String getAppId() {
    if (Platform.isIOS) {
      return IOS_APP_ID;
    } else if (Platform.isAndroid) {
      return ANDROID_APP_ID;
    }
    return null;
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return IOS_AD_UNIT_BANNER;
    } else if (Platform.isAndroid) {
      return ANDROID_AD_UNIT_BANNER;
    }
    return null;
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: getBannerAdUnitId(),
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  // Used to avoid banner overlapping with floatingActionButton
  double getSmartBannerHeight(MediaQueryData mediaQuery) {
    // https://developers.google.com/admob/android/banner#smart_banners
    if (Platform.isAndroid) {
      if (mediaQuery.size.height > 720) return 90.0;
      if (mediaQuery.size.height > 400) return 50.0;
      return 32.0;
    }
    // https://developers.google.com/admob/ios/banner#smart_banners
    // Smart Banners on iPhones have a height of 50 points in portrait and 32 points in landscape.
    // On iPads, height is 90 points in both portrait and landscape.
    if (Platform.isIOS) {
      // TODO use https://pub.dartlang.org/packages/device_info to detect iPhone/iPad?
      // if (iPad) return 90.0;
      if (mediaQuery.orientation == Orientation.portrait) return 50.0;
      return 32.0;
    }
    // No idea, just return a common value.
    return 50.0;
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'import', icon: Icons.cloud_download),
  Choice(title: 'export', icon: Icons.backup),
  Choice(title: 'signout', icon: Icons.exit_to_app),
];
