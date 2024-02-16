import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:system_info_plus/system_info_plus.dart';
import 'dart:async';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: 'Device Information',
      color:Colors.blue,
       debugShowCheckedModeBanner:false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Tab> tabs;
  late List<Widget> tabViews;
  late DeviceInfoPlugin deviceInfo;
  late SystemInfoPlus _systemInfoPlus=SystemInfoPlus();

  _MyHomePageState() {
    _systemInfoPlus = SystemInfoPlus(); 
  }

  @override
  void initState() {
    super.initState();
    deviceInfo = DeviceInfoPlugin();
  ();
    tabs = [
      Tab(text: 'Device'),
      Tab(text: 'Android'),
      Tab(text: 'RAM'),
    ];
    tabViews = [
      DeviceTab(deviceInfo: deviceInfo),
      AndroidTab(deviceInfo: deviceInfo),
      RAM(systemInfo: _systemInfoPlus),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Device Information'),
          bottom: TabBar(
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: tabViews,
        ),
      ),
    );
  }
}

class DeviceTab extends StatelessWidget {
  final DeviceInfoPlugin deviceInfo;

  const DeviceTab({Key? key, required this.deviceInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDeviceInfo(),
      builder: (context, AsyncSnapshot<AndroidDeviceInfo> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          var info = snapshot.data!;
          return ListView(
            children: [
              ListTile(
                title: Text('Device'),
                subtitle: Text(info.device),
              ),
              ListTile(
                title: Text('Serial Number'),
                subtitle: Text(info.serialNumber),
              ),
              ListTile(
                title: Text('Model'),
                subtitle: Text(info.model),
              ),
               ListTile(
                title: const Text('Device Type'),
                subtitle: Text(info.type),
              ),
              ListTile(
                title: const Text('Version Codename'),
                subtitle: Text(info.version.codename),
              ),
               ListTile(
                title: const Text('Display'),
                subtitle: Text(info.display),
              ),
               ListTile(
                title: const Text('Board'),
                subtitle: Text(info.board),
              ),
               ListTile(
                title: const Text('Brand'),
                subtitle: Text(info.brand),
              ),
               ListTile(
                title: const Text('Hardware'),
                subtitle: Text(info.hardware),
              ),
               ListTile(
                title: const Text('Device ID'),
                subtitle: Text(info.id),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return Container(); 
      },
    );
  }

  Future<AndroidDeviceInfo> _getDeviceInfo() async {
    return await deviceInfo.androidInfo;
  }
}

class AndroidTab extends StatelessWidget {
  final DeviceInfoPlugin deviceInfo;

  const AndroidTab({Key? key, required this.deviceInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAndroidInfo(),
      builder: (context, AsyncSnapshot<AndroidDeviceInfo> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          var info = snapshot.data!;
          return ListView(
            children: [
              ListTile(
                title: Text('Android Version'),
                subtitle: Text(info.version.release),
              ),
              ListTile(
                title: Text('API Level'),
                subtitle: Text(info.version.sdkInt.toString()),
              ),
              
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return Container(); 
      },
    );
  }

  Future<AndroidDeviceInfo> _getAndroidInfo() async {
    return await deviceInfo.androidInfo;
  }
}
class RAM extends StatelessWidget {
  final SystemInfoPlus systemInfo;

  const RAM({Key? key, required this.systemInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SystemInfoPlus.physicalMemory,
      builder: (context, AsyncSnapshot<int?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          int? ramSize = snapshot.data;
          return ListView(
            children: [
              ListTile(
                title: Text('Random Access Memory: ${ramSize ?? "Unknown"} MB (Megabytes)'),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return Container(); 
      },
    );
  }
}

