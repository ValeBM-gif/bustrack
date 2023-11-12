import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;

class Parada{
  int id;
  String direccion;
  maps.LatLng posicion;

  Parada({required this.id, required this.direccion, required this.posicion});
}

List<Parada> paradas=[
  Parada(id: 3, direccion: 'Blv. Juan Alonso De Torres Y Calle Del Llano', posicion: maps.LatLng(21.1468218, -101.7099781)),
  Parada(id: 4, direccion: 'Casi Esquina con Blvd. Paseo de los Insurgentes', posicion: maps.LatLng(21.1466770, -101.7089709)),
  Parada(id: 5, direccion: 'Blvd. Paseo de los Insurgentes Y Instituto Hispano Inglés', posicion: maps.LatLng(21.1465413, -101.7090909)),
  Parada(id: 6, direccion: 'Rio Mariches E Insurgentes', posicion: maps.LatLng(21.1463220, -101.7088926)),
    Parada(id: 7, direccion: 'Insurgentes Y Real De Mariches', posicion: maps.LatLng(21.1463027, -101.7093692)),
  Parada(id: 8, direccion: 'Calle Loma Del Pino Y Calle Cima Del Sol', posicion: maps.LatLng(21.1509868, -101.7115773)),
  Parada(id: 9, direccion: 'Calle Cima Del Sol Y Calle Loma Del Madroño', posicion: maps.LatLng(21.1543779, -101.7107978)),
];