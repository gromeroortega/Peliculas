/* Powered by Zharka Curso de Flutter Udemy*/
//Importación de la librería de Widgets de Flutter
import 'package:flutter/material.dart';

//Importación de archivos a los que se hace referencia
import 'package:curso_peliculas/src/pages/home_page.dart';
import 'src/pages/home_page.dart';

/*Clase principal para ejecución de la app main.
runApp: metodo contructor que busca la clase principal para ejecutarla.
Myapp(): Clase contructora de la app */
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override //Palabra reservada para sobre escribir clases.

  Widget build(BuildContext context) {
    //Se seobre escribe el constructor que retorna
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
      },
    );
  }
}
