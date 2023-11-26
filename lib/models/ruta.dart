import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;


class Ruta {
  int id;
  String nombre;
  String direccion;
  TipoDeRuta? tipo;
  maps.LatLng? posicion1;
  maps.LatLng? posicion2;
  List<PolylineWayPoint>? puntosDeRuta;

  Ruta({
    required this.id,
    required this.nombre,
    required this.direccion,
    this.tipo,
    this.posicion1,
    this.posicion2,
    this.puntosDeRuta
  });
}

enum TipoDeRuta{
  troncal,
  alimentadora,
  auxiliar,
  convencional
}

List<Ruta> rutas = [
  Ruta(
      id: 1,
      nombre: 'L1',
      direccion: 'San Jerónimo - Delta por Blvr. A. López Mateos',
      tipo: TipoDeRuta.troncal,
      posicion1: maps.LatLng(21.149740, -101.675124),
      posicion2: maps.LatLng(21.095032, -101.616753),
      puntosDeRuta: [
        PolylineWayPoint(location: "21.149740, -101.675124",), 
        PolylineWayPoint(location: "21.147860, -101.677145",),
        PolylineWayPoint(location: "21.147404, -101.681210"),
        PolylineWayPoint(location: "21.147187, -101.684586"),
        PolylineWayPoint(location: "21.144113, -101.685584"),
        PolylineWayPoint(location: "21.138683, -101.686643"),
        PolylineWayPoint(location: "21.131212, -101.687910"),
        PolylineWayPoint(location: "21.127533, -101.686557"),
        PolylineWayPoint(location: "21.126639, -101.684842"),
        PolylineWayPoint(location: "21.123580, -101.676720"),
        PolylineWayPoint(location: "21.092751, -101.623347"),
        PolylineWayPoint(location: "21.089984, -101.620207"),
        PolylineWayPoint(location: "21.093855, -101.617333"),
        PolylineWayPoint(location: "21.095032, -101.616753"),
      ]
  ),
  Ruta(
      id: 2,
      nombre: 'L2',
      direccion: 'San Jerónimo - Delta por Blvr. Miguel Hidalgo',
      tipo: TipoDeRuta.troncal,
      posicion1: maps.LatLng(21.1512901, -101.71211448),
      posicion2: maps.LatLng(21.1435029, -101.7021371)
  ),
  Ruta(
      id: 3,
      nombre: 'L3',
      direccion: 'San Juan Bosco - San Jerónimo',
      tipo: TipoDeRuta.troncal,
      posicion1: maps.LatLng(21.1349831, -101.7163692),
      posicion2: maps.LatLng(21.1358256, -101.6783201)
  ),
  Ruta(
      id: 4,
      nombre: 'A-01',
      direccion: 'Las Hilamas - Terminal San Juan Bosco',
      tipo: TipoDeRuta.alimentadora,
      posicion1: maps.LatLng(21.1074388, -101.7261092),
      posicion2: maps.LatLng(21.1349831, -101.6783201)
  ),
  Ruta(
      id: 5,
      nombre: 'A-02',
      direccion: 'Adquirientes de Ibarrilla - Terminal San Jerónimo',
      tipo: TipoDeRuta.alimentadora,
      posicion1: maps.LatLng(21.1349831, -101.7261092),
      posicion2: maps.LatLng(21.1358256, -101.7021371)
  ),
  Ruta(
      id: 6,
      nombre: 'X-01',
      direccion: 'Terminal San Juan Bosco - Micro estación Santa Rita - Terminal Timoteo Lozano',
      tipo: TipoDeRuta.auxiliar,
      posicion1: maps.LatLng(21.1445607, -101.6735626),
      posicion2: maps.LatLng(21.1358256, -101.6783201)
  ),
  Ruta(
      id: 7,
      nombre: 'X-02',
      direccion: 'Real del Castillo - Terminal Delta',
      tipo: TipoDeRuta.auxiliar,
      posicion1: maps.LatLng(21.1445607, -101.6735626),
      posicion2: maps.LatLng(21.1358256, -101.6783201)
  ),
  Ruta(
      id: 8,
      nombre: 'R-04',
      direccion: 'CEPOL - Col. Jesús de Nazareth',
      tipo: TipoDeRuta.convencional,
      posicion1: maps.LatLng(21.1445607, -101.6735626),
      posicion2: maps.LatLng(21.1358256, -101.6783201)
  ),
  Ruta(
      id: 9,
      nombre: 'L3',
      direccion: 'Col. Alfaro - Centro',
      tipo: TipoDeRuta.convencional,
      posicion1: maps.LatLng(21.1445607, -101.6735626),
      posicion2: maps.LatLng(21.1358256, -101.6783201)
  ),
  Ruta(
      id: 10,
      nombre: 'A-82',
      direccion: 'Col. Urbi Villa Del Roble - Terminal San Juan Bosco',
      tipo: TipoDeRuta.alimentadora,
      posicion1: const maps.LatLng(21.165827, -101.760463),
      posicion2: const maps.LatLng(21.131095, -101.715344)
  ),
  Ruta(
      id: 11,
      nombre: 'A-91',
      direccion: 'Col. Paseo del Country - Terminal San Juan Bosco',
      tipo: TipoDeRuta.alimentadora,
      posicion1: const maps.LatLng(21.153727, -101.731702),
      posicion2: const maps.LatLng(21.131095, -101.715344)
  ),
  Ruta(
      id: 12,
      nombre: 'A-31',
      direccion: 'Terminal San Juan Bosco - Col. Colinas de la Fragua',
      tipo: TipoDeRuta.alimentadora,
      posicion1: const maps.LatLng(21.153466, -101.743129),
      posicion2: const maps.LatLng(21.128305, -101.714448)
  ),
];
