import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class SourceView extends StatefulWidget {
  final String url;
  const SourceView({super.key, required this.url});

  @override
  State<SourceView> createState() => _SourceViewState();
}

class _SourceViewState extends State<SourceView> {
  InAppWebViewController? webViewController;

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.white,
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          initialUserScripts: UnmodifiableListView<UserScript>([]),
          initialSettings: settings,
          onWebViewCreated: (controller) async {},
          onLoadStart: (controller, url) async {},
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url!;

            if (![
              "http",
              "https",
              "file",
              "chrome",
              "data",
              "javascript",
              "about"
            ].contains(uri.scheme)) {
              if (await canLaunchUrl(uri)) {
                // Launch the App
                await launchUrl(
                  uri,
                );
                // and cancel the request
                return NavigationActionPolicy.CANCEL;
              }
            }

            return NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, url) async {},
          onReceivedError: (controller, request, error) {},
          onProgressChanged: (controller, progress) {},
          onUpdateVisitedHistory: (controller, url, isReload) {},
          onConsoleMessage: (controller, consoleMessage) {},
        ),
      ),
    );
  }
}
