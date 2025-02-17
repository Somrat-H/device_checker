import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DeviceCheckScreen(),
    );
  }
}

class DeviceCheckScreen extends StatefulWidget {
  @override
  _DeviceCheckScreenState createState() => _DeviceCheckScreenState();
}

class _DeviceCheckScreenState extends State<DeviceCheckScreen> {
  bool isDeveloperMode = false;
  bool isRooted = false;

  @override
  void initState() {
    super.initState();
    checkDeveloperMode();
    checkRootStatus();
  }

  /// Check if Developer Mode is enabled
  Future<void> checkDeveloperMode() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          isDeveloperMode = androidInfo.isPhysicalDevice == false;
        });
      } else if (Platform.isIOS) {
        setState(() {
          isDeveloperMode = false; // iOS doesn't expose Developer Mode state
        });
      }
    } catch (e) {
      print("Error checking developer mode: $e");
    }
  }

  /// Check if the device is rooted
  Future<void> checkRootStatus() async {
    try {
      if (Platform.isAndroid) {
        const MethodChannel channel = MethodChannel('root_check');
        final bool result = await channel.invokeMethod('isDeviceRooted');
        setState(() {
          isRooted = result;
        });
      } else {
        setState(() {
          isRooted = false; // iOS does not allow root detection easily
        });
      }
    } catch (e) {
      print("Error checking root status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Device Security Check")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Developer Mode: ${isDeveloperMode ? "Enabled" : "Disabled"}"),
            Text("Root Access: ${isRooted ? "Yes" : "No"}"),
          ],
        ),
      ),
    );
  }
}
