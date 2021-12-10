//Import librerias de dart
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
//Imports de archivos del proyecto
import 'package:curso_peliculas/src/models/actores_models.dart';
import 'package:curso_peliculas/src/models/pelicula_model.dart';

//Clase principal Peliculas
class PeliculasProvider {
  String _apikey = 'apikey';
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
  // El controller esta es mi tuberia siempre se debe especificar que va a pasar por el stream
  // Para este caso es una <Lista<Peliculas>>. El broadcast perimite al Satrem escuchar desde
  // cualquier parte de la app
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

  /*Cierre de Stream, aquí no se usa pero es neceraria*/
  void disposeStream() {
    _popularesStreamCtr?.close();
  }

  /*Termina el codigo del Stream*/

  //Método que hace la petición al API, es un future que devuelve una lista de datos.
  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    //En la variable "resp" espera y almacena la respuesta de la URL que se almacena en la variable "url"
    final resp = await http.get(url);
    //En la variable decodeData se decodifica el JSON almacenado en "resp"
    final decodeData = json.decode(resp.body);
    //En la variable "pelis" almacena la respuesta mapeada con el método fromJson del modelo peliculas.
    final pelis = new Peliculas.fromJsonList(decodeData['results']);
    //Retorna los datos mapeados.
    return pelis.items;
  }

  //Método que construye la url para obtener las películas que estan en cines, y llama al método proocesarRespuesta.
  Future<List<Pelicula>> getEnCines() async {
    //Suma uno a la variable que almacena el número de la página
    _pageCines++;
    //Construye la url del servicio a consumir.
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language,
      'page': _pageCines.toString()
    });
    //print(url);
    //Retorna la respues del metodo procesarRespuesta
    return await _procesarRespuesta(url);
  }

  //Método que construye la url para obtener las películas populares y llama al método porcesarRespuesta.
  //
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
    //Al agregar la lista que esta almacenada en respuesta a _populares se debe definar el
    //tipo de dato de _populares y es <List<Pelicula>>
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

  Future<List<Pelicula>> burscarPelicula(String query) async {
    //Suma uno a la variable que almacena el número de la página
    _pageCines++;
    //Construye la url del servicio a consumir.
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});
    //print(url);
    //Retorna la respues del metodo procesarRespuesta
    return await _procesarRespuesta(url);
  }
}
