import '../widgets/rutas_list_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;

class Lugar {
  int id;
  String nombre;
  String direccion;
  double? distanciaDesdeOrigen;
  double? tiempoDeLlegada;
  maps.LatLng posicion;

  Lugar(
      {required this.id,
      required this.nombre,
      required this.direccion,
      required this.posicion,
      this.distanciaDesdeOrigen,
      this.tiempoDeLlegada});
}

List<Lugar> lugaresBuscadosRecientemente = [
  Lugar(
    id: 0,
    nombre: 'Plaza Mayor',
    direccion: 'Boulevard Juan Alonso de Torres',
    distanciaDesdeOrigen: 1.8,
    tiempoDeLlegada: calcularTiempoLlegadaDestino().toDouble(),
    posicion: const maps.LatLng(21.156024, -101.694192),
  ),
  Lugar(
    id: 1,
    nombre: 'Rockstar Burger',
    direccion: 'Boulevard Lopez Mateos',
    distanciaDesdeOrigen: 2.8,
    tiempoDeLlegada: calcularTiempoLlegadaDestino().toDouble(), posicion: const maps.LatLng(21.141200, -101.686365),
  ),
  Lugar(
    id: 2,
    nombre: 'Universidad La Salle Bajío',
    direccion: 'Avenida Universidad, Lomas del Campestre',
    distanciaDesdeOrigen: 1.2,
    tiempoDeLlegada: calcularTiempoLlegadaDestino().toDouble(), posicion: const maps.LatLng(21.154145, -101.711608),
  ),
  Lugar(
    id: 3,
    nombre: 'Costco Wholesale',
    direccion: 'Eugenio Garza Sada, Lomas del Campestre',
    distanciaDesdeOrigen: 1.0,
    tiempoDeLlegada: calcularTiempoLlegadaDestino().toDouble(), posicion: const maps.LatLng(21.155936, -101.705160),
  ),
  Lugar(
    id: 4,
    nombre: 'Sushi Roll',
    direccion: 'Boulevard Juan Alonso de Torres',
    distanciaDesdeOrigen: 1.6,
    tiempoDeLlegada: calcularTiempoLlegadaDestino().toDouble(), posicion: const maps.LatLng(21.158809, -101.696881),
  ),
];
