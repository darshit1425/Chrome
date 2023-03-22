import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Web_provider extends ChangeNotifier{
  double progressWeb=0;
  InAppWebViewController?inAppWebViewController;
  void changeProgress(double Ps){
    progressWeb=Ps;
    notifyListeners();
  }


}