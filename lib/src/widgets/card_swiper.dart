import 'package:curso_peliculas/src/models/pelicula_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

//Clase para crear un carrusel de tarjetas mediante la importación del package flutter_swiper
class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;
  CardSwiper({@required this.peliculas});
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.only(top: 10.0),
        //color: Colors.amberAccent,
        child: Swiper(
          layout: SwiperLayout.STACK,
          itemHeight: _screenSize.width * 1.03,
          itemWidth: _screenSize.height * 0.3,
          itemBuilder: (BuildContext context, int index) {
            peliculas[index].peliculak = '${peliculas[index].id}-tarjeta';
            return Hero(
              tag: peliculas[index].id,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: GestureDetector(
                    onTap: () {
                      //Manda los argumentos "arguments", a la ruta definida "detalle" en el main.
                      Navigator.pushNamed(context, 'detalle',
                          arguments: peliculas[index]);
                    },
                    child: FadeInImage(
                      image: NetworkImage(
                        peliculas[index].getPosterImg(),
                      ),
                      placeholder: AssetImage('assets/no-image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  )),
            );
          },
          itemCount: peliculas.length,
          //pagination: new SwiperPagination(),
          //control: new SwiperControl(),
        ));
  }
}
