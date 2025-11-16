// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Api_Provider/imageupload_api.dart';
import '../../widgets/widgets.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class SenangPay extends StatefulWidget {
  final String email;
  final String totalAmount;
  final String name;
  final String phon;

  const SenangPay({
    super.key,
    required this.email,
    required this.totalAmount,
    required this.name,
    required this.phon,
  });

  @override
  State<SenangPay> createState() => _SenangPayState();
}

class _SenangPayState extends State<SenangPay> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic progress;
  late WebViewController _controller;
  String? accessToken;
  String? payerID;
  bool isLoading = true;
  dynamic postdata;

  @override
  void initState() {
    super.initState();
    setState(() {
      final notificationId = UniqueKey().hashCode;
      postdata = "detail=Movers&amount=${widget.totalAmount}&order_id=$notificationId&name=${widget.name}&email=${widget.email}&phone=${widget.phon}";
      isLoading = false;
    });

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
                final uri = Uri.parse(request.url);
                 debugPrint("************ queryParamiter: ${uri.queryParametersAll}");
                if (uri.queryParameters["msg"] == null) {
                  accessToken = uri.queryParameters["token"];
                } else {
                  if (uri.queryParameters["msg"] == "Payment_was_successful") {
                    payerID = uri.queryParameters["transaction_id"];
                    Get.back(result: payerID);
                  } else {
                    Get.back();
                    showCommonToast(msg: "${uri.queryParameters["msg"]}");
                  }
                }
                return NavigationDecision.navigate;
              },
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
              onProgress: (val) {
                setState(() {
                  progress = val;
                });
              },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )

      ..loadRequest(Uri.parse("$basUrl/result.php?$postdata"));
    debugPrint("URL------- $basUrl/result.php?$postdata");
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;

  }

  @override
  Widget build(BuildContext context) {
    if (_scaffoldKey.currentState == null) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: isLoading
            ? const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              )
            : Scaffold(
                body: SafeArea(
                  child: Stack(
                    children: [
                      WebViewWidget(controller: _controller),
                      isLoading
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    child: CircularProgressIndicator(),
                                  ),
                                  SizedBox(height: Get.height * 0.02),
                                  SizedBox(
                                    width: Get.width * 0.80,
                                    child: Text(
                                      'Please don`t press back until the transaction is complete'
                                          .tr,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const Stack(),
                    ],
                  ),
                ),
              ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
//http://15.207.11.52/lorriz/index.php?amt=100&email=test@gmail.com
//http://15.207.11.52/lorriz/flutterwave/index.php?amt=100&email=test@gmail.com