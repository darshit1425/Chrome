import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../provider/webprovider.dart';

class Web_Screen extends StatefulWidget {
  const Web_Screen({Key? key}) : super(key: key);

  @override
  State<Web_Screen> createState() => _Web_ScreenState();
}

class _Web_ScreenState extends State<Web_Screen> {
  Web_provider? ProviderT;
  Web_provider? ProviderF;
  TextEditingController TxtSearch = TextEditingController();
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    pullToRefreshController = PullToRefreshController(
      onRefresh: () {
        ProviderT!.inAppWebViewController?.reload();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProviderT = Provider.of<Web_provider>(context, listen: true);
    ProviderF = Provider.of<Web_provider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white10,
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    ProviderT!.inAppWebViewController!.goBack();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ProviderT!.inAppWebViewController!.reload();
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ProviderT!.inAppWebViewController!.goForward();
                  },
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    color: Colors.black26,
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: TxtSearch,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "search Google or type URL ",
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        prefixIcon: IconButton(
                          onPressed: () {
                            var newSearch = TxtSearch.text;
                            ProviderT!.inAppWebViewController!.loadUrl(
                              urlRequest: URLRequest(
                                url: Uri.parse(
                                    "https://www.google.com/search?q=$newSearch"),
                              ),
                            );
                          },
                          icon: Icon(Icons.search),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            LinearProgressIndicator(
              color: Colors.grey,
              value: ProviderT!.progressWeb,
            ),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse("https://www.google.com/"),
                ),
                pullToRefreshController: pullToRefreshController!,
                onWebViewCreated: (controller) {
                  ProviderT!.inAppWebViewController = controller;
                },
                onLoadError: (controller, url, code, message) {
                  pullToRefreshController!.endRefreshing();
                  ProviderT!.inAppWebViewController = controller;
                },
                onLoadStart: (controller, url) {
                  ProviderT!.inAppWebViewController = controller;
                },
                onLoadStop: (controller, url) {
                  pullToRefreshController!.endRefreshing();

                  ProviderT!.inAppWebViewController = controller;
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController!.endRefreshing();
                  }
                  ProviderF!.changeProgress(progress / 100);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
