class Populars {
  List<Popular> items = [];
  Populars.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (final item in jsonList) {
      final pelicula = new Popular.fromJsonMap(item);
      items.add(pelicula);
    }
  }
}

class Popular {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  String releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  Popular({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  Popular.fromJsonMap(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    genreIds = json['genre_ids'].cast<int>();
    id = json['id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'] / 1;
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'] / 1;
    voteCount = json['vote_count'];
  }

  getPopularImg() {
    if (posterPath == null) {
      return 'https://vcunited.club/wp-content/uploads/2020/01/No-image-available-2.jpg';
    } else {
      return 'https://www.themoviedb.org/t/p/original/$posterPath';
    }
  }
}
