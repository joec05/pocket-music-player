// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_listen_count_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAudioListenCountModelCollection on Isar {
  IsarCollection<AudioListenCountModel> get audioListenCountModels =>
      this.collection();
}

const AudioListenCountModelSchema = CollectionSchema(
  name: r'AudioListenCountModel',
  id: 1138550309641119371,
  properties: {
    r'audioUrl': PropertySchema(
      id: 0,
      name: r'audioUrl',
      type: IsarType.string,
    ),
    r'listenCount': PropertySchema(
      id: 1,
      name: r'listenCount',
      type: IsarType.long,
    )
  },
  estimateSize: _audioListenCountModelEstimateSize,
  serialize: _audioListenCountModelSerialize,
  deserialize: _audioListenCountModelDeserialize,
  deserializeProp: _audioListenCountModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _audioListenCountModelGetId,
  getLinks: _audioListenCountModelGetLinks,
  attach: _audioListenCountModelAttach,
  version: '3.1.0+1',
);

int _audioListenCountModelEstimateSize(
  AudioListenCountModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.audioUrl.length * 3;
  return bytesCount;
}

void _audioListenCountModelSerialize(
  AudioListenCountModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.audioUrl);
  writer.writeLong(offsets[1], object.listenCount);
}

AudioListenCountModel _audioListenCountModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AudioListenCountModel(
    reader.readString(offsets[0]),
    reader.readLong(offsets[1]),
  );
  object.id = id;
  return object;
}

P _audioListenCountModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _audioListenCountModelGetId(AudioListenCountModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _audioListenCountModelGetLinks(
    AudioListenCountModel object) {
  return [];
}

void _audioListenCountModelAttach(
    IsarCollection<dynamic> col, Id id, AudioListenCountModel object) {
  object.id = id;
}

extension AudioListenCountModelQueryWhereSort
    on QueryBuilder<AudioListenCountModel, AudioListenCountModel, QWhere> {
  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AudioListenCountModelQueryWhere on QueryBuilder<AudioListenCountModel,
    AudioListenCountModel, QWhereClause> {
  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AudioListenCountModelQueryFilter on QueryBuilder<
    AudioListenCountModel, AudioListenCountModel, QFilterCondition> {
  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> audioUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> audioUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> audioUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> audioUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> audioUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'audioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> audioUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'audioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
          QAfterFilterCondition>
      audioUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'audioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
          QAfterFilterCondition>
      audioUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'audioUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> audioUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> audioUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'audioUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> listenCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'listenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> listenCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'listenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> listenCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'listenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel,
      QAfterFilterCondition> listenCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'listenCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AudioListenCountModelQueryObject on QueryBuilder<
    AudioListenCountModel, AudioListenCountModel, QFilterCondition> {}

extension AudioListenCountModelQueryLinks on QueryBuilder<AudioListenCountModel,
    AudioListenCountModel, QFilterCondition> {}

extension AudioListenCountModelQuerySortBy
    on QueryBuilder<AudioListenCountModel, AudioListenCountModel, QSortBy> {
  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterSortBy>
      sortByAudioUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioUrl', Sort.asc);
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterSortBy>
      sortByAudioUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioUrl', Sort.desc);
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterSortBy>
      sortByListenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listenCount', Sort.asc);
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterSortBy>
      sortByListenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listenCount', Sort.desc);
    });
  }
}

extension AudioListenCountModelQuerySortThenBy
    on QueryBuilder<AudioListenCountModel, AudioListenCountModel, QSortThenBy> {
  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterSortBy>
      thenByAudioUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioUrl', Sort.asc);
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterSortBy>
      thenByAudioUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioUrl', Sort.desc);
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterSortBy>
      thenByListenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listenCount', Sort.asc);
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QAfterSortBy>
      thenByListenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listenCount', Sort.desc);
    });
  }
}

extension AudioListenCountModelQueryWhereDistinct
    on QueryBuilder<AudioListenCountModel, AudioListenCountModel, QDistinct> {
  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QDistinct>
      distinctByAudioUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AudioListenCountModel, AudioListenCountModel, QDistinct>
      distinctByListenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'listenCount');
    });
  }
}

extension AudioListenCountModelQueryProperty on QueryBuilder<
    AudioListenCountModel, AudioListenCountModel, QQueryProperty> {
  QueryBuilder<AudioListenCountModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AudioListenCountModel, String, QQueryOperations>
      audioUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioUrl');
    });
  }

  QueryBuilder<AudioListenCountModel, int, QQueryOperations>
      listenCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'listenCount');
    });
  }
}
