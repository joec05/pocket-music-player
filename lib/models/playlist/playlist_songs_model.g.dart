// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_songs_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlaylistSongsModelCollection on Isar {
  IsarCollection<PlaylistSongsModel> get playlistSongsModels =>
      this.collection();
}

const PlaylistSongsModelSchema = CollectionSchema(
  name: r'PlaylistSongsModel',
  id: -7359447097913267566,
  properties: {
    r'creationDate': PropertySchema(
      id: 0,
      name: r'creationDate',
      type: IsarType.string,
    ),
    r'imageBytes': PropertySchema(
      id: 1,
      name: r'imageBytes',
      type: IsarType.longList,
    ),
    r'playlistID': PropertySchema(
      id: 2,
      name: r'playlistID',
      type: IsarType.string,
    ),
    r'playlistName': PropertySchema(
      id: 3,
      name: r'playlistName',
      type: IsarType.string,
    ),
    r'songsList': PropertySchema(
      id: 4,
      name: r'songsList',
      type: IsarType.stringList,
    )
  },
  estimateSize: _playlistSongsModelEstimateSize,
  serialize: _playlistSongsModelSerialize,
  deserialize: _playlistSongsModelDeserialize,
  deserializeProp: _playlistSongsModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _playlistSongsModelGetId,
  getLinks: _playlistSongsModelGetLinks,
  attach: _playlistSongsModelAttach,
  version: '3.1.0+1',
);

int _playlistSongsModelEstimateSize(
  PlaylistSongsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.creationDate.length * 3;
  {
    final value = object.imageBytes;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  bytesCount += 3 + object.playlistID.length * 3;
  bytesCount += 3 + object.playlistName.length * 3;
  bytesCount += 3 + object.songsList.length * 3;
  {
    for (var i = 0; i < object.songsList.length; i++) {
      final value = object.songsList[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _playlistSongsModelSerialize(
  PlaylistSongsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.creationDate);
  writer.writeLongList(offsets[1], object.imageBytes);
  writer.writeString(offsets[2], object.playlistID);
  writer.writeString(offsets[3], object.playlistName);
  writer.writeStringList(offsets[4], object.songsList);
}

PlaylistSongsModel _playlistSongsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlaylistSongsModel(
    reader.readString(offsets[2]),
    reader.readString(offsets[3]),
    reader.readLongList(offsets[1]),
    reader.readString(offsets[0]),
    reader.readStringList(offsets[4]) ?? [],
  );
  object.id = id;
  return object;
}

P _playlistSongsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLongList(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playlistSongsModelGetId(PlaylistSongsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playlistSongsModelGetLinks(
    PlaylistSongsModel object) {
  return [];
}

void _playlistSongsModelAttach(
    IsarCollection<dynamic> col, Id id, PlaylistSongsModel object) {
  object.id = id;
}

extension PlaylistSongsModelQueryWhereSort
    on QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QWhere> {
  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlaylistSongsModelQueryWhere
    on QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QWhereClause> {
  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterWhereClause>
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

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterWhereClause>
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

extension PlaylistSongsModelQueryFilter
    on QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QFilterCondition> {
  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      creationDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      creationDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'creationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      creationDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'creationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      creationDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'creationDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      creationDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'creationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      creationDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'creationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      creationDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'creationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      creationDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'creationDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      creationDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creationDate',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      creationDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'creationDate',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
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

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
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

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
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

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      imageBytesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imageBytes',
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      imageBytesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imageBytes',
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      imageBytesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      imageBytesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      imageBytesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      imageBytesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      imageBytesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imageBytes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      imageBytesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imageBytes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      imageBytesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imageBytes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      imageBytesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imageBytes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      imageBytesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imageBytes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      imageBytesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'imageBytes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistIDEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playlistID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistIDGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playlistID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistIDLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playlistID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistIDBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playlistID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistIDStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'playlistID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistIDEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'playlistID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistIDContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playlistID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistIDMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playlistID',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistIDIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playlistID',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistIDIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playlistID',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playlistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playlistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playlistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playlistName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'playlistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'playlistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playlistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playlistName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playlistName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      playlistNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playlistName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'songsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'songsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'songsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'songsList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'songsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'songsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'songsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'songsList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'songsList',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'songsList',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'songsList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'songsList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'songsList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'songsList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'songsList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterFilterCondition>
      songsListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'songsList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension PlaylistSongsModelQueryObject
    on QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QFilterCondition> {}

extension PlaylistSongsModelQueryLinks
    on QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QFilterCondition> {}

extension PlaylistSongsModelQuerySortBy
    on QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QSortBy> {
  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterSortBy>
      sortByCreationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterSortBy>
      sortByCreationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterSortBy>
      sortByPlaylistID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistID', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterSortBy>
      sortByPlaylistIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistID', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterSortBy>
      sortByPlaylistName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistName', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterSortBy>
      sortByPlaylistNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistName', Sort.desc);
    });
  }
}

extension PlaylistSongsModelQuerySortThenBy
    on QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QSortThenBy> {
  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterSortBy>
      thenByCreationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterSortBy>
      thenByCreationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creationDate', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterSortBy>
      thenByPlaylistID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistID', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterSortBy>
      thenByPlaylistIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistID', Sort.desc);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterSortBy>
      thenByPlaylistName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistName', Sort.asc);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QAfterSortBy>
      thenByPlaylistNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playlistName', Sort.desc);
    });
  }
}

extension PlaylistSongsModelQueryWhereDistinct
    on QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QDistinct> {
  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QDistinct>
      distinctByCreationDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creationDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QDistinct>
      distinctByImageBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageBytes');
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QDistinct>
      distinctByPlaylistID({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playlistID', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QDistinct>
      distinctByPlaylistName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playlistName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QDistinct>
      distinctBySongsList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'songsList');
    });
  }
}

extension PlaylistSongsModelQueryProperty
    on QueryBuilder<PlaylistSongsModel, PlaylistSongsModel, QQueryProperty> {
  QueryBuilder<PlaylistSongsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlaylistSongsModel, String, QQueryOperations>
      creationDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creationDate');
    });
  }

  QueryBuilder<PlaylistSongsModel, List<int>?, QQueryOperations>
      imageBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageBytes');
    });
  }

  QueryBuilder<PlaylistSongsModel, String, QQueryOperations>
      playlistIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playlistID');
    });
  }

  QueryBuilder<PlaylistSongsModel, String, QQueryOperations>
      playlistNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playlistName');
    });
  }

  QueryBuilder<PlaylistSongsModel, List<String>, QQueryOperations>
      songsListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'songsList');
    });
  }
}
