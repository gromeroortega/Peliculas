import 'dart:convert';
import 'dart:async';
import 'package:curso_peliculas/src/models/actores_models.dart';
import 'package:curso_peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apikey = '689b60a9ca482470f05cd372ec59e840';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _pagePopular = 0;
  int _pageCines = 0;
  bool _cargando = false;
  String movieId;
  /*Inicica codigo del Stream*/

  //Crea
  List<Pelicula> _populares = [];

  //Broadcast para escuchar en muchos lugares
  // El controller esta es mi tuberia
  final _popularesStreamCtr = StreamController<List<Pelicula>>.broadcast();

  /*En estos gets se renombra la instancia del stream, para no instancialos cada que los necesitemos*/
  /*Skin es la forma para insertar/agregar información...
  Esta función agrega Pelicula a mi stream  
  */
  Function(List<Pelicula>) get popularesSink => _popularesStreamCtr.sink.add;

  /*Stream es para escuchar, las orejas de mi stream...
   Este es get ecucha la pelicula.
  */
  Stream<List<Pelicula>> get popularesStream => _popularesStreamCtr.stream;

  void disposeStream() {
    _popularesStreamCtr?.close();
  }

  /*Termina el codigo del Stream*/
  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final pelis = new Peliculas.fromJsonList(decodeData['results']);
    return pelis.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    _pageCines++;
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language,
      'page': _pageCines.toString()
    });
    //print(url);
    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulars() async {
    if (_cargando) return [];

    _cargando = true;
    _pagePopular++;

    //print('cargando más peliculas...');
    //print(_cargando);

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _pagePopular.toString()
    });
    //print(url);

    final respuesta = await _procesarRespuesta(url);

    _populares.addAll(respuesta);
    //Desde aquí se agrega el sink al Scream.
    popularesSink(_populares);
    _cargando = false;
    //print('Segundo $_cargando');
    return respuesta;
  }

  Future<List<Actor>> getActores(String movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits', {
      'api_key': _apikey,
      'language': _language,
    });

    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final cast = new Actores.fromJsonList(decodeData['cast']);

    return cast.actores;
  }
}
