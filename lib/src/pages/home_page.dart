import 'package:curso_peliculas/src/providers/provider_peliculas.dart';
import 'package:curso_peliculas/src/widgets/card_swiper.dart';
import 'package:curso_peliculas/src/widgets/movie_horizontal.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final peliculas = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculas.getPopulars();
    return Scaffold(
        appBar: AppBar(
          title: Text('Películas'),
          backgroundColor: Colors.indigoAccent,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {})
          ],
        ),
        body: Container(
          child:
              Column(children: <Widget>[_swiperTarjetas(), _footer(context)]),
        ));
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculas.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Populares',
                    style: Theme.of(context).textTheme.headline5)),
            StreamBuilder(
              stream: peliculas.popularesStream,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  return MovieHorizontal(
                      //La propiedad siguientePelicula se crea en el home_page como una funcion.
                      peliculas: snapshot.data,
                      siguientePagina: peliculas.getPopulars);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ));
  }
}
