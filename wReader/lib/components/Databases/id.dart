final String tableID = 'tableId';

class IdFields {
  static final List<String> values = [
    id,
    source,
  ];

  static final String id = '_id';
  static final String source = 'source';
}

class ID {
  final int? id;
  final String? source;

  const ID({
    this.id,
    this.source,
  });
  ID copy({
    int? id,
    String? source,
  }) =>
      ID(
        id: id ?? this.id,
        source: source ?? this.source,
      );

  static ID fromJson(Map<String, Object?> json) => ID(
        id: json[IdFields.id] as int,
        source: json[IdFields.source] as String,
      );

  Map<String, Object> toJson() => {
        IdFields.id: id!,
        IdFields.source: source!,
      };
}
