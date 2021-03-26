import 'package:curso_peliculas/src/models/actores_models.dart';
import 'package:curso_peliculas/src/models/pelicula_model.dart';
import 'package:curso_peliculas/src/providers/provider_peliculas.dart';
import 'package:flutter/material.dart';

/*Recibe argumentos del PushNamed */
class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppbar(pelicula),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(height: 10.0),
          _posterTitulo(pelicula, context),
          _descripcion(pelicula),
          _crearActores(pelicula)
        ]))
      ],
    ));
  }

  Widget _crearAppbar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.grey,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white70, fontSize: 16.0),
        ),
        background: FadeInImage(
          fit: BoxFit.cover,
          //fadeInDuration: Duration(microseconds: 150),
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage(
            pelicula.getBackgroundPath(),
          ),
        ),
      ),
    );
  }

  Widget _posterTitulo(Pelicula pelicula, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
                height: 150.0,
                image: NetworkImage(
                  pelicula.getPosterImg(),
                )),
          ),
          SizedBox(
            width: 20.0,
          ),
          Flexible(
            child: Column(
              children: [
                Text(pelicula.title,
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center),
                Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                SizedBox(
                  height: 10.0,
                ),
                Text(pelicula.originalTitle,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    Text(
                      pelicula.voteAverage.toString(),
                      style: Theme.of(context).textTheme.subtitle1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearActores(Pelicula pelicula) {
    final peli = new PeliculasProvider();

    return FutureBuilder(
      future: peli.getActores(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 250.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: actores.length,
        itemBuilder: (contex, i) => _actores(actores[i]),
      ),
    );
  }

  Widget _actores(Actor actor) {
    return Container(
      //padding: EdgeInsets.all(3.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
                height: 180.0,
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(actor.getActorImg())),
          ),
          Text(actor.name)
        ],
      ),
    );
  }
}
