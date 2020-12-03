// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_news.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataAdapter extends TypeAdapter<Data> {
  @override
  final int typeId = 0;

  @override
  Data read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Data(
      articles: (fields[0] as List)?.cast<Articles>(),
      status: fields[1] as String,
      totalResults: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Data obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.articles)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.totalResults);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ArticlesAdapter extends TypeAdapter<Articles> {
  @override
  final int typeId = 1;

  @override
  Articles read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Articles(
      source: fields[3] as Source,
      author: fields[4] as String,
      content: fields[5] as String,
      description: fields[6] as String,
      publishedAt: fields[7] as String,
      title: fields[8] as String,
      url: fields[9] as String,
      urlToImage: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Articles obj) {
    writer
      ..writeByte(8)
      ..writeByte(3)
      ..write(obj.source)
      ..writeByte(4)
      ..write(obj.author)
      ..writeByte(5)
      ..write(obj.content)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.publishedAt)
      ..writeByte(8)
      ..write(obj.title)
      ..writeByte(9)
      ..write(obj.url)
      ..writeByte(10)
      ..write(obj.urlToImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticlesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SourceAdapter extends TypeAdapter<Source> {
  @override
  final int typeId = 2;

  @override
  Source read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Source(
      id: fields[11] as String,
      name: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Source obj) {
    writer
      ..writeByte(2)
      ..writeByte(11)
      ..write(obj.id)
      ..writeByte(12)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _FetchNews implements FetchNews {
  _FetchNews(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://newsapi.org/v2';
  }

  final Dio _dio;

  String baseUrl;

  @override
  getNews() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/top-headlines?country=in&apiKey=10d4f658d9174a68ad6b03e6851dd586',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = Data.fromJson(_result.data);
    return value;
  }
}
