import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebViewPage extends StatefulWidget {
  final String appName;
  final String version;
  final String route;

  const WebViewPage({
    super.key,
    required this.appName,
    required this.version,
    required this.route,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? _webViewController;

  final _isLoading = true.obs;
  final _progress = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(
                  'https://web-user-support.web.app/',
                ),
              ),
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED,
                );
              },
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                databaseEnabled: true,
                cacheEnabled: false,
                clearCache: true,
                allowsInlineMediaPlayback: true,
                mediaPlaybackRequiresUserGesture: false,
                useHybridComposition: false,
                hardwareAcceleration: true,
                useOnLoadResource: true,
                allowFileAccess: true,
                allowContentAccess: true,
                allowFileAccessFromFileURLs: true,
                allowUniversalAccessFromFileURLs: true,
                javaScriptCanOpenWindowsAutomatically: true,
              ),
              onWebViewCreated: (controller) async {
                _webViewController = controller;

                controller.addJavaScriptHandler(
                  handlerName: 'closeWebView',
                  callback: (args) {
                    if (mounted) Navigator.pop(context);
                  },
                );
              },
              onLoadStart: (controller, url) {
                _isLoading.value = true;
                _progress.value = 0.0;
              },
              onProgressChanged: (controller, progress) {
                _progress.value = progress / 100;

                if (progress == 100) {
                  _isLoading.value = false;
                }
              },
              onLoadStop: (controller, url) async {
                final appInfo = {
                  "version": widget.version,
                  "appName": widget.appName,
                  "currentRoute": widget.route,
                };
                await controller.evaluateJavascript(
                  source: """
                    window.APP_INFO = ${jsonEncode(appInfo)};
                    window.dispatchEvent(new Event('appInfoReady'));
                     """,
                );
              },
            ),
            Obx(
              () => _isLoading.value
                  ? Container(
                      color: Colors.white,
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text("Đang tải..."),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isLoading.close();
    super.dispose();
  }
}
