import 'package:realm/realm.dart';

part 'app.g.dart'; // declare a part file.

@RealmModel()
class _Car {
  @PrimaryKey()
  late ObjectId id;
  late String make;
  late String? model;
  late int? miles;
}

var config = Configuration.local([Car.schema]);
var realm = Realm(config);

final car = Car(ObjectId(), 'Tesla', model: 'Model S', miles: 42);
