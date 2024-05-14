// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_song_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFavouriteSongModelCollection on Isar {
  IsarCollection<FavouriteSongModel> get favouriteSongModels =>
      this.collection();
}

const FavouriteSongModelSchema = CollectionSchema(
  name: r'FavouriteSongModel',
  id: 8422172182306955243,
  properties: {
    r'songPath': PropertySchema(
      id: 0,
      name: r'songPath',
      type: IsarType.string,
    )
  },
  estimateSize: _favouriteSongModelEstimateSize,
  serialize: _favouriteSongModelSerialize,
  deserialize: _favouriteSongModelDeserialize,
  deserializeProp: _favouriteSongModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _favouriteSongModelGetId,
  getLinks: _favouriteSongModelGetLinks,
  attach: _favouriteSongModelAttach,
  version: '3.1.0+1',
);

int _favouriteSongModelEstimateSize(
  FavouriteSongModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.songPath.length * 3;
  return bytesCount;
}

void _favouriteSongModelSerialize(
  FavouriteSongModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.songPath);
}

FavouriteSongModel _favouriteSongModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FavouriteSongModel(
    reader.readString(offsets[0]),
  );
  object.id = id;
  return object;
}

P _favouriteSongModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _favouriteSongModelGetId(FavouriteSongModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _favouriteSongModelGetLinks(
    FavouriteSongModel object) {
  return [];
}

void _favouriteSongModelAttach(
    IsarCollection<dynamic> col, Id id, FavouriteSongModel object) {
  object.id = id;
}

extension FavouriteSongModelQueryWhereSort
    on QueryBuilder<FavouriteSongModel, FavouriteSongModel, QWhere> {
  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FavouriteSongModelQueryWhere
    on QueryBuilder<FavouriteSongModel, FavouriteSongModel, QWhereClause> {
  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterWhereClause>
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

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterWhereClause>
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

extension FavouriteSongModelQueryFilter
    on QueryBuilder<FavouriteSongModel, FavouriteSongModel, QFilterCondition> {
  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterFilterCondition>
      songPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'songPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterFilterCondition>
      songPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'songPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterFilterCondition>
      songPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'songPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterFilterCondition>
      songPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'songPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterFilterCondition>
      songPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'songPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterFilterCondition>
      songPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'songPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterFilterCondition>
      songPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'songPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterFilterCondition>
      songPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'songPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterFilterCondition>
      songPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'songPath',
        value: '',
      ));
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterFilterCondition>
      songPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'songPath',
        value: '',
      ));
    });
  }
}

extension FavouriteSongModelQueryObject
    on QueryBuilder<FavouriteSongModel, FavouriteSongModel, QFilterCondition> {}

extension FavouriteSongModelQueryLinks
    on QueryBuilder<FavouriteSongModel, FavouriteSongModel, QFilterCondition> {}

extension FavouriteSongModelQuerySortBy
    on QueryBuilder<FavouriteSongModel, FavouriteSongModel, QSortBy> {
  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterSortBy>
      sortBySongPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songPath', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterSortBy>
      sortBySongPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songPath', Sort.desc);
    });
  }
}

extension FavouriteSongModelQuerySortThenBy
    on QueryBuilder<FavouriteSongModel, FavouriteSongModel, QSortThenBy> {
  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterSortBy>
      thenBySongPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songPath', Sort.asc);
    });
  }

  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QAfterSortBy>
      thenBySongPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'songPath', Sort.desc);
    });
  }
}

extension FavouriteSongModelQueryWhereDistinct
    on QueryBuilder<FavouriteSongModel, FavouriteSongModel, QDistinct> {
  QueryBuilder<FavouriteSongModel, FavouriteSongModel, QDistinct>
      distinctBySongPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'songPath', caseSensitive: caseSensitive);
    });
  }
}

extension FavouriteSongModelQueryProperty
    on QueryBuilder<FavouriteSongModel, FavouriteSongModel, QQueryProperty> {
  QueryBuilder<FavouriteSongModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FavouriteSongModel, String, QQueryOperations>
      songPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'songPath');
    });
  }
}
