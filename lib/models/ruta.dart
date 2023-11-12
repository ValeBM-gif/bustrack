import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;


class Ruta {
  int id;
  String nombre;
  String direccion;
  TipoDeRuta? tipo;
  maps.LatLng? posicion1;
  maps.LatLng? posicion2;

  Ruta({
    required this.id,
    required this.nombre,
    required this.direccion,
    this.tipo,
    this.posicion1,
    this.posicion2
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
      posicion1: maps.LatLng(21.1445607, -101.6735626),
      posicion2: maps.LatLng(21.1358256, -101.6783201)
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
];
