import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../AppConstData/app_colors.dart';
import '../Api_Provider/imageupload_api.dart';
import '../../widgets/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PayTmPayment extends StatefulWidget {
  final String? uid;
  final String? totalAmount;

  const PayTmPayment({super.key, this.uid, this.totalAmount});

  @override
  State<PayTmPayment> createState() => _PayTmPaymentState();
}

class _PayTmPaymentState extends State<PayTmPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late WebViewController _controller;
  var progress;
  String? accessToken;
  String? payerID;
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();

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

            if (uri.queryParameters["status"] == null) {
              accessToken = uri.queryParameters["token"];
            } else {
              if (uri.queryParameters["status"] == "successful") {
                payerID = uri.queryParameters["transaction_id"];
                Get.back(result: payerID);
              } else {
                Get.back();
                showCommonToast(msg: "${uri.queryParameters["status"]}");
              }
            }
            return NavigationDecision.navigate;
          },
          
          // gestureNavigationEnabled: true,
            onPageStarted: (url) {
              debugPrint(url);
            },
            // onWebViewCreated: (controller) {},
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

      ..loadRequest(Uri.parse("${basUrl}paytm/index.php?amt=${widget.totalAmount}&uid=${widget.uid}"));
    debugPrint("URL------- ${basUrl}paytm/index.php?amt=${widget.totalAmount}&uid=${widget.uid}");
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
        child: Scaffold(
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
                            SizedBox(
                              child: CircularProgressIndicator(
                                color: priMaryColor,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
                            SizedBox(
                              width: Get.width * 0.80,
                              child: Text(
                                'Please don`t press back until the transaction is complete'.tr,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
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
        body: Center(
          child: CircularProgressIndicator(
            color: priMaryColor,
          ),
        ),
      );
    }
  }
}
