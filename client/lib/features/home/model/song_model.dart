class SongModel{
  // ignore_for_file: non_constant_identifier_names

  final String song_name;
  final String song_url;
  final String thumbnail_url;
  final String artist;
  final String hex_code;
  final String id;

  //<editor-fold desc="Data Methods">
  const SongModel({
    required this.song_name,
    required this.song_url,
    required this.thumbnail_url,
    required this.artist,
    required this.hex_code,
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongModel &&
          runtimeType == other.runtimeType &&
          song_name == other.song_name &&
          song_url == other.song_url &&
          thumbnail_url == other.thumbnail_url &&
          artist == other.artist &&
          hex_code == other.hex_code &&
          id == other.id);

  @override
  int get hashCode =>
      song_name.hashCode ^
      song_url.hashCode ^
      thumbnail_url.hashCode ^
      artist.hashCode ^
      hex_code.hashCode ^ id.hashCode;

  @override
  String toString() {
    return 'SongModel{' +
        ' song_name: $song_name,' +
        ' song_url: $song_url,' +
        ' thumbnail_url: $thumbnail_url,' +
        ' artist: $artist,' +
        ' hexCode: $hex_code,' +
        '}';
  }

  SongModel copyWith({
    String? song_name,
    String? song_url,
    String? thumbnail_url,
    String? artist,
    String? hexCode,
    String? id
  }) {
    return SongModel(
      song_name: song_name ?? this.song_name,
      song_url: song_url ?? this.song_url,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
      artist: artist ?? this.artist,
      hex_code: hexCode ?? hex_code,
      id : id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'song_name': song_name,
      'song_url': song_url,
      'thumbnail_url': thumbnail_url,
      'artist': artist,
      'hex_code': hex_code,
      'id': id,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'song_name': song_name,
      'song_url': song_url,
      'thumbnail_url': thumbnail_url,
      'artist':artist,
      'hexCode': hex_code,
      'id' : id,
    };
  }



  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      song_name: map['song_name'] ?? '',
      song_url: map['song_url']  ?? '',
      thumbnail_url: map['thumbnail_url']  ?? '',
      artist: map['artist']  ?? '',
      hex_code: map['hex_code']  ?? '',
      id:  map['id'] ?? '',
    );
  }
  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      song_name: json['song_name'] ?? '',
      song_url: json['song_url'] ?? '',
      thumbnail_url: json['thumbnail_url'] ?? '',
      artist: json['artist'] ?? '',
      hex_code: json['hex_code'] ?? '',
      id: json['id'] ?? '',
    );
  }


//</editor-fold>
}