import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart'; // For kIsWeb

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (kIsWeb) {
      // Local notifications are not typically used on web in the same way
      print("Local notifications not initialized for web.");
      return;
    }

    try {
      // Initialize timezone database safely
      tz.initializeTimeZones();
      try {
        // Try multiple timezone approaches for better compatibility
        try {
          // First try to use local timezone
          final String timezoneName = tz.local.name;
          tz.setLocalLocation(tz.getLocation(timezoneName));
          print("✅ Set timezone to local: $timezoneName");
        } catch (e) {
          // If local timezone fails, try common alternatives
          try {
            tz.setLocalLocation(tz.getLocation("UTC"));
            print("✅ Set timezone to UTC");
          } catch (e2) {
            // Last resort - use first available timezone
            final availableTimezones = tz.timeZoneDatabase.locations.keys.toList();
            if (availableTimezones.isNotEmpty) {
              final firstTimezone = availableTimezones.first;
              tz.setLocalLocation(tz.getLocation(firstTimezone));
              print("✅ Set timezone to first available: $firstTimezone");
            } else {
              print("⚠️ No timezones available in database");
            }
          }
        }
      } catch (e) {
        print("⚠️ Error setting timezone location: $e");
        // Continue without setting specific timezone
      }

      // Safely initialize notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon'); // Use default app_icon instead of mipmap reference

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      );

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      );

      // Create a default Android channel (important for Android 8.0+)
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'task_due_channel', // id
        'Task Due Reminders', // title
        description: 'Channel for task due date reminders.', // description
        importance: Importance.high,
      );

      try {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
      } catch (e) {
        print("⚠️ Error creating notification channel: $e");
        // Continue even if channel creation fails
      }

      // Request permissions for Android 13+ and iOS
      if (!kIsWeb) {
        try {
          final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
              flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();
          await androidImplementation?.requestNotificationsPermission();
          await _requestIOSPermissions(); // This handles iOS
        } catch (e) {
          print("⚠️ Error requesting notification permissions: $e");
          // Continue even if permission request fails
        }
      }
      print("✅ Notification service initialized successfully");
    } catch (e) {
      print("❌ Critical error initializing notification service: $e");
      // Allow app to continue even if notifications fail completely
    }
  }

  Future<void> _requestIOSPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  // Callback for when a notification is tapped
  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    // Here you could navigate to a specific task if you pass task ID in payload
    // e.g., MyApp.navigatorKey.currentState?.pushNamed('/task-details', arguments: payload);
  }

  // Callback for older iOS versions (before iOS 10)
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, navigating to a specific page if needed.
    debugPrint('onDidReceiveLocalNotification: id=$id, title=$title, payload=$payload');
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    if (kIsWeb) return; // No local notifications on web for this simple setup

    // Ensure the scheduled time is in the future
    if (scheduledDate.isBefore(DateTime.now())) {
        print("Attempted to schedule notification in the past. Ignoring.");
        return;
    }

    // Log details for debugging
    print("🔔 Scheduling notification with ID: $id");
    print("🔔 Title: $title");
    print("🔔 Due time: $scheduledDate");
    
    // Create notification details
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'task_due_channel', // Channel ID
        'Task Due Reminders', // Channel Name
        channelDescription: 'Channel for task due date reminders.',
        importance: Importance.high,
        priority: Priority.high,
        // Remove icon parameter to use default
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
      print("✅ Notification successfully scheduled for id $id at $scheduledDate");
    } catch (e) {
      print("❌ Error scheduling notification: $e");
    }
  }

  Future<void> cancelNotification(int id) async {
    if (kIsWeb) return;
    
    try {
      // Ensure ID is within 32-bit range for Android compatibility
      final int safeId = id & 0x7FFFFFFF; // Mask to positive 31-bit integer
      
      await flutterLocalNotificationsPlugin.cancel(safeId);
      print("✅ Cancelled notification with id $safeId (original id: $id)");
    } catch (e) {
      print("⚠️ Error cancelling notification: $e");
      // Continue app execution even if notification cancellation fails
    }
  }

  Future<void> cancelAllNotifications() async {
    if (kIsWeb) return;
    await flutterLocalNotificationsPlugin.cancelAll();
    print("Cancelled all notifications");
  }

  // Schedule a test notification that will fire in 5 seconds
  Future<void> scheduleImmediateTestNotification() async {
    if (kIsWeb) return;
    
    try {
      final int testId = DateTime.now().millisecondsSinceEpoch % 2147483647;
      final DateTime scheduledTime = DateTime.now().add(const Duration(seconds: 5));
      
      print("🔔 Scheduling test notification for 5 seconds from now");
      print("🔔 Current time: ${DateTime.now()}");
      print("🔔 Scheduled time: $scheduledTime");
      
      // Use a simpler approach with direct scheduling
      await flutterLocalNotificationsPlugin.zonedSchedule(
        testId,
        '⏰ Scheduled Test (5s)',
        'This notification was scheduled to appear 5 seconds after you pressed the button.',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'task_due_channel',
            'Task Due Reminders',
            channelDescription: 'Channel for task due date reminders.',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
      
      print("✅ Test notification scheduled for 5 seconds from now");
    } catch (e) {
      print("❌ Error scheduling test notification: $e");
      
      // Fallback to immediate notification if scheduling fails
      try {
        final int testId = DateTime.now().millisecondsSinceEpoch % 2147483647;
        print("🔔 Falling back to immediate notification due to scheduling error");
        
        await flutterLocalNotificationsPlugin.show(
          testId,
          '⏰ Fallback Test Notification',
          'This is an immediate notification shown because scheduled notifications might not be working.',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'task_due_channel',
              'Task Due Reminders',
              channelDescription: 'Channel for task due date reminders.',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
        );
        print("✅ Fallback notification shown immediately");
      } catch (e2) {
        print("❌ Critical error: Both scheduled and immediate notifications failed: $e2");
      }
    }
  }

  // Test notification using the same channel as scheduled notifications
  Future<void> showTestNotification() async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'task_due_channel', // Using same channel as scheduled notifications
        'Task Due Reminders',
        channelDescription: 'Channel for task due date reminders.',
        importance: Importance.high,
        priority: Priority.high,
        // Remove icon parameter
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    
    try {
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch % 2147483647, // Dynamic ID to avoid conflicts
        'Test Notification',
        'This is a test notification from NotificationService.',
        notificationDetails,
      );
      print("✅ Test notification shown successfully");
    } catch (e) {
      print("❌ Error showing test notification: $e");
    }
  }
} 