import 'package:curso_peliculas/src/models/pelicula_model.dart';
import 'package:flutter/material.dart';

/*Recibe argumentos del PushNamed */
class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Center(
        child: Text('Detalle ${pelicula.title} '),
      ),
    );
  }
}
