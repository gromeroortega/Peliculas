import 'package:curso_peliculas/src/models/pelicula_model.dart';
import 'package:flutter/material.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });
    return Container(
        padding: EdgeInsets.all(15.0),
        //color: Colors.black,
        height: _screenSize.height * 0.30,
        child: PageView.builder(
          pageSnapping: false,
          controller: _pageController,
          itemCount: peliculas
              .length, //Le dice el builder ccuentos items va a renderizar
          itemBuilder: (contex, i) {
            return _crearTarjeta(contex, peliculas[i]);
          },
          //children: _tarjetas(context),
        ));
  }

  Widget _crearTarjeta(BuildContext context, Pelicula pelicula) {
    final tarjeta = Container(
      margin: EdgeInsets.only(right: 1.0),
      //color: Colors.amber,
      child: Column(
        children: <Widget>[
          Hero(
            tag: pelicula.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/no-image.jpg'),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        //Manda los argumentos "arguments", a la ruta definida "detalle" en el main.
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }
/* Código sustituido por _crear tarjetas*/

/*
  List<Widget> _tarjetas(BuildContext context, Pelicula pelicula) {
    return peliculas.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 1.0),
        //color: Colors.amber,
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/no-image.jpg'),
                height: 150.0,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }*/
}
