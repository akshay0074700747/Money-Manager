

import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/hive/model_class.dart';

class Boxes {
  static Box<transactions> gettransactions(){
    return Hive.box<transactions>('transactions');
    }
    static Box<futuretransactions> getfuturetransactions(){
      return Hive.box<futuretransactions>('futuretransactions');
}
}