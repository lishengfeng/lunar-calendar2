// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// A simple "rough and ready" example of localizing a Flutter app.
// Spanish and English (locale language codes 'en' and 'es') are
// supported.

// The pubspec.yaml file must include flutter_localizations in its
// dependencies section. For example:
//
// dependencies:
//   flutter:
//   sdk: flutter
//  flutter_localizations:
//    sdk: flutter

// If you run this app with the device's locale set to anything but
// English or Spanish, the app's locale will be English. If you
// set the device's locale to Spanish, the app's locale will be
// Spanish.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter_localizations/flutter_localizations.dart';

class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Lunar Calendar Synchronizer',
      'welcome': 'Welcome to the App!',
      'welcome_desc':
          'Just getting start? Let\'s take a look at some great feature of this app.',
      'walkthrough_add': 'Add a lunar event',
      'walkthrough_add_desc':
          'Adding lunar event is quite simple. Just like adding an event in Google Calendar.',
      'walkthrough_sync': 'Sync to Google Calendar',
      'walkthrough_sync_desc':
          'This app will automatically convert your lunar event to solar event and sync them to your Google Calendar.',
      'walkthrough_reinstall': 'Reinstall app?',
      'walkthrough_reinstall_desc':
          'Just import your lunar events from your Google Calendar back to app. You will retrieve all your inputs w/o retyping again.',
      'walkthrough_get_start': 'Get Started',
      'sign_in_requirement_desc':
          'Since the app aims to work with Google Calendar, please sign in with your Google Account first.',
      'sign_in_with_google': 'Sign in with Google',
      'import': 'Import',
      'export': 'Export',
      'no_calendars_found': 'There is no calendar found',
      'choose_a_lunar_calendar': 'Choose an existing lunar calendar',
      'got_error': 'Got error',
      'no_events_try_to_add_some':
          'You do not have any events yet. Please try to add some.',
      'to': 'to',
      'loading_calendars': 'Loading calendars...',
      'loading_lunar_events': 'Loading lunar events',
      'no_events_to_export': 'There are no lunar events to be exported.',
      'syncing': 'Syncing',
      'google_calendar_api_return_code':
          'Google Calenndar API gave a failed response. code: ',
      'calendar_title': 'Title',
      'calendar_title_hint': 'e.g. mom\'s birthday',
      'calendar_event_start': 'Event start date',
      'calendar_event_start_hint': 'e.g. 01-31',
      'invalid_date': 'Invalid date',
      'calendar_event_end': 'Event end date',
      'calendar_event_end_hint': 'e.g. 01-31',
      'calendar_repeat_type': 'Repeat type',
      'calendar_repeat_type_annually': 'Annually',
      'calendar_repeat_type_monthly': 'Monthly',
      'calendar_repeat_type_no': 'No repeat',
      'calendar_repeat_time_label': 'Repeat times (1-99)',
      'calendar_repeat_time_hint': 'e.g. 80',
      'invalid_number': 'Invalid number',
      'calendar_location': 'Location (Optional)',
      'calendar_location_hint':
          'e.g. 1600 Amphitheatre Parkway Mountain View, CA',
      'calendar_notification': 'Notification',
      'save': 'Save',
      'cancel': 'Cancel',
      'calendar_reminder_notification': 'Notification',
      'calendar_reminder_email': 'Email',
      'calendar_reminder_days': 'days',
      'calendar_reminder_weeks': 'weeks',
      'calendar_reminder_before_at': ' before at ',
      'notification_title': 'Notification',
      'notification_type': 'Notification type',
      'notification_days_weeks_before': 'days/weeks before',
      'notification_days_weeks_before_hint': 'e.g. 1d (1-27) or 1w (1-3)',
      'invalid_value': 'Invalid value',
      'notification_remind_time': 'Remind time (24-hour format)',
      'notification_remind_time_hint': 'e.g. 09:00',
      'invalid_time': 'Invalid time',
    },
    'zh': {
      'title': '农历新历转换器',
      'welcome': '欢迎使用app!',
      'welcome_desc': '第一次使用? 看看有什么功能吧.',
      'walkthrough_add': '添加一个农历事件',
      'walkthrough_add_desc': '添加农历事件非常简单, 就像在谷歌日历添加一个事件一样.',
      'walkthrough_sync': '同步到谷歌日历',
      'walkthrough_sync_desc': 'App会将您的农历事件转换到新历事件并同步到谷歌日历.',
      'walkthrough_reinstall': '重新安装app?',
      'walkthrough_reinstall_desc': '只需要从谷歌日历重新导入您的农历日历,所有的农历事件都会恢复,不需要重新输入.',
      'walkthrough_get_start': '开始使用',
      'sign_in_requirement_desc': '因为App需要使用谷歌日历服务,请先登录您的谷歌帐号.',
      'sign_in_with_google': '登录谷歌',
      'import': '导入',
      'export': '导出',
      'no_calendars_found': '未发现日历',
      'choose_a_lunar_calendar': '请选择一个农历日历',
      'got_error': '发现错误',
      'no_events_try_to_add_some': '无农历事件, 请尝试添加农历事件.',
      'to': '至',
      'loading_calendars': '读取日历中...',
      'loading_lunar_events': '读取农历事件中...',
      'no_events_to_export': '无农历事件用于导出.',
      'syncing': '同步中',
      'google_calendar_api_return_code': '谷歌日历返回错误. 代码: ',
      'calendar_title': '标题',
      'calendar_title_hint': '例: 妈妈生日',
      'calendar_event_start': '事件开始日期',
      'calendar_event_start_hint': '例: 01-31',
      'invalid_date': '无效日期',
      'calendar_event_end': '事件结束日期',
      'calendar_event_end_hint': '例: 01-31',
      'calendar_repeat_type': '重复类型',
      'calendar_repeat_type_annually': '每年',
      'calendar_repeat_type_monthly': '每月',
      'calendar_repeat_type_no': '无',
      'calendar_repeat_time_label': '重复次数 (1-99)',
      'calendar_repeat_time_hint': '例: 80',
      'invalid_number': '无效数字',
      'calendar_location': '地址 (可选)',
      'calendar_location_hint': '例: 某省某市某县某路1号',
      'calendar_notification': '提醒',
      'save': '保存',
      'cancel': '取消',
      'calendar_reminder_notification': '提醒',
      'calendar_reminder_email': '电子邮件',
      'calendar_reminder_days': '天',
      'calendar_reminder_weeks': '周',
      'calendar_reminder_before_at': ' 提前 ',
      'notification_title': '提醒',
      'notification_type': '提醒类型',
      'notification_days_weeks_before': '天/周 提前',
      'notification_days_weeks_before_hint':
          '例: 1d 或者 1w. d=天(1-27). w=周(1-3)',
      'invalid_value': '无效值',
      'notification_remind_time': '提醒时间 (24小时制)',
      'notification_remind_time_hint': '例: 09:00',
      'invalid_time': '无效时间',
    },
  };

  Map<String, String> get localizedValues {
    return _localizedValues[locale.languageCode];
  }
}

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
