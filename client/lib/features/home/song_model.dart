class SongModel{
  // ignore_for_file: non_constant_identifier_names

  final String song_name;
  final String song_url;
  final String thumbnail_url;
  final String artist;
  final String hexCode;

  //<editor-fold desc="Data Methods">
  const SongModel({
    required this.song_name,
    required this.song_url,
    required this.thumbnail_url,
    required this.artist,
    required this.hexCode,
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
          hexCode == other.hexCode);

  @override
  int get hashCode =>
      song_name.hashCode ^
      song_url.hashCode ^
      thumbnail_url.hashCode ^
      artist.hashCode ^
      hexCode.hashCode;

  @override
  String toString() {
    return 'SongModel{' +
        ' song_name: $song_name,' +
        ' song_url: $song_url,' +
        ' thumbnail_url: $thumbnail_url,' +
        ' artist: $artist,' +
        ' hexCode: $hexCode,' +
        '}';
  }

  SongModel copyWith({
    String? song_name,
    String? song_url,
    String? thumbnail_url,
    String? artist,
    String? hexCode,
  }) {
    return SongModel(
      song_name: song_name ?? this.song_name,
      song_url: song_url ?? this.song_url,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
      artist: artist ?? this.artist,
      hexCode: hexCode ?? this.hexCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'song_name': song_name,
      'song_url': song_url,
      'thumbnail_url': thumbnail_url,
      'artist':artist,
      'hexCode': hexCode,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      song_name: map['song_name'] ?? '',
      song_url: map['song_url']  ?? '',
      thumbnail_url: map['thumbnail_url']  ?? '',
      artist: map['artist']  ?? '',
      hexCode: map['hexCode']  ?? '',
    );
  }

  //</editor-fold>
}