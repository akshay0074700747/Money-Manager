import 'package:hive_flutter/hive_flutter.dart';
part 'model_class.g.dart';


@HiveType(typeId: 0)
class transactions extends HiveObject{
  @HiveField(0)
  late String transaction_name;
  @HiveField(1)
  late String transaction_note;
  @HiveField(2)
  late double transaction_amount;
  @HiveField(3)
  late DateTime transaction_date;
  @HiveField(4)
  late bool isexpence=true;

}

@HiveType(typeId: 1)
class futuretransactions extends HiveObject{
  @HiveField(0)
  late String transaction_name;
  @HiveField(1)
  late String transaction_note;
  @HiveField(2)
  late double transaction_amount;
  @HiveField(3)
  late DateTime transaction_date;
  @HiveField(4)
  late bool isexpence=true;

}