import 'package:flutter_easyloading/flutter_easyloading.dart';

int counter = 0;

increaseCounter(){
  if(counter == 0){
    EasyLoading.show(dismissOnTap: false);
  }
  counter++;
}

decreseCounter(){
  counter--;
  if(counter == 0){
    EasyLoading.dismiss();
  }
}