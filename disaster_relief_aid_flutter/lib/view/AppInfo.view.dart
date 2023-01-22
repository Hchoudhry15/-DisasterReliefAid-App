import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:disaster_relief_aid_flutter/main.dart';

import '../component/Toast.component.dart';

class AppInfoView extends StatefulWidget {
  const AppInfoView({super.key});

  @override
  State<AppInfoView> createState() => _AppInfoViewState();
}

class _AppInfoViewState extends State<AppInfoView> {
  bool _loadingVersion = true;
  late PackageInfo _packageInfo;
  late FToast ftoast;

  @override
  Widget build(BuildContext context) {
    if (_loadingVersion) {
      PackageInfo.fromPlatform().then((value) {
        setState(() {
          _packageInfo = value;
          _loadingVersion = false;
        });
      });
    }
    return Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: const Text('App Information'),
        ),
        body: _buildWithVersionInfo(context));
  }

  _buildWithVersionInfo(BuildContext context) {
    return _loadingVersion
        ? const Center(child: CircularProgressIndicator())
        : _buildBody(context);
  }

  _buildBody(BuildContext context) {
    ftoast = FToast();
    ftoast.init(globalKey.currentState!.context);
    return SingleChildScrollView(
        child: Column(
      children: [
        // const HeadingListTile(labelText: "App Info"),
        // const Divider(),
        Column(children: [
          ListTile(
            title: const Text("App Name"),
            subtitle: Text(_packageInfo.appName),
            onLongPress: () {
              _copyToClipboard(_packageInfo.appName);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Package Name"),
            subtitle: Text(_packageInfo.packageName),
            onLongPress: () {
              _copyToClipboard(_packageInfo.packageName);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Version"),
            subtitle: Text(_packageInfo.version),
            onLongPress: () {
              _copyToClipboard(_packageInfo.version);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Build Number"),
            subtitle: Text(_packageInfo.buildNumber),
            onLongPress: () {
              _copyToClipboard(_packageInfo.buildNumber);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Build Signature"),
            subtitle: Text(_packageInfo.buildSignature),
            onLongPress: () {
              _copyToClipboard(_packageInfo.buildSignature);
            },
          ),
        ]),
      ],
    ));
  }

  _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    // show toast
    // ftoast.showToast(
    //   child: const ConfirmToast(labelText: "Copied to clipboard"),
    //   gravity: ToastGravity.BOTTOM,
    //   toastDuration: const Duration(seconds: 2),
    // );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
