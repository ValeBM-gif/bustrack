import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class BusLocationProvider with ChangeNotifier{
  LocationData? _busLoc;

  LocationData? get getBusLoc => _busLoc;

  Future<void> initFromFirebase()async{
    final firestore = FirebaseFirestore.instance;
    CollectionReference col = firestore.collection('coordenadasUsuario');
    DocumentSnapshot document = await col.doc('bus').get();
    if(document.exists){
      print('doc existe');
      var latitud = document['lat'];
      var longitude = document['lon'];
      if (latitud != null) {
        _busLoc = LocationData.fromMap({
          'latitude': latitud,
          'longitude': longitude,
        });
        print('si cambio bus loc?? ${_busLoc!.latitude}');
      }else{
        print('lat null');
      }
    }else{
      print('doc no existe');
    }
    notifyListeners();
  }

  void setBusLoc(loc){
    _busLoc=loc;
    print('loc seteada $_busLoc');
    notifyListeners();
  }
}