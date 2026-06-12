// This is a generated file - do not edit.
//
// Generated from fs/scene_map/scene_map.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/any.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class IntVectorProto extends $pb.GeneratedMessage {
  factory IntVectorProto({
    $core.Iterable<$core.int>? values,
  }) {
    final result = create();
    if (values != null) result.values.addAll(values);
    return result;
  }

  IntVectorProto._();

  factory IntVectorProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IntVectorProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IntVectorProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'fs.scene_map'),
      createEmptyInstance: create)
    ..p<$core.int>(1, _omitFieldNames ? '' : 'values', $pb.PbFieldType.K3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IntVectorProto clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IntVectorProto copyWith(void Function(IntVectorProto) updates) =>
      super.copyWith((message) => updates(message as IntVectorProto))
          as IntVectorProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IntVectorProto create() => IntVectorProto._();
  @$core.override
  IntVectorProto createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IntVectorProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IntVectorProto>(create);
  static IntVectorProto? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.int> get values => $_getList(0);
}

class FloatVectorProto extends $pb.GeneratedMessage {
  factory FloatVectorProto({
    $core.Iterable<$core.double>? values,
  }) {
    final result = create();
    if (values != null) result.values.addAll(values);
    return result;
  }

  FloatVectorProto._();

  factory FloatVectorProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FloatVectorProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FloatVectorProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'fs.scene_map'),
      createEmptyInstance: create)
    ..p<$core.double>(1, _omitFieldNames ? '' : 'values', $pb.PbFieldType.KF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FloatVectorProto clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FloatVectorProto copyWith(void Function(FloatVectorProto) updates) =>
      super.copyWith((message) => updates(message as FloatVectorProto))
          as FloatVectorProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FloatVectorProto create() => FloatVectorProto._();
  @$core.override
  FloatVectorProto createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FloatVectorProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FloatVectorProto>(create);
  static FloatVectorProto? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.double> get values => $_getList(0);
}

class PositionedComponentProto extends $pb.GeneratedMessage {
  factory PositionedComponentProto({
    $fixnum.Int64? id,
    IntVectorProto? position,
    FloatVectorProto? scale,
    $core.double? angle,
    $core.Iterable<$0.Any>? children,
    IntVectorProto? size,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (position != null) result.position = position;
    if (scale != null) result.scale = scale;
    if (angle != null) result.angle = angle;
    if (children != null) result.children.addAll(children);
    if (size != null) result.size = size;
    return result;
  }

  PositionedComponentProto._();

  factory PositionedComponentProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PositionedComponentProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PositionedComponentProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'fs.scene_map'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOM<IntVectorProto>(2, _omitFieldNames ? '' : 'position',
        subBuilder: IntVectorProto.create)
    ..aOM<FloatVectorProto>(3, _omitFieldNames ? '' : 'scale',
        subBuilder: FloatVectorProto.create)
    ..aD(4, _omitFieldNames ? '' : 'angle', fieldType: $pb.PbFieldType.OF)
    ..pPM<$0.Any>(5, _omitFieldNames ? '' : 'children',
        subBuilder: $0.Any.create)
    ..aOM<IntVectorProto>(6, _omitFieldNames ? '' : 'size',
        subBuilder: IntVectorProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PositionedComponentProto clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PositionedComponentProto copyWith(
          void Function(PositionedComponentProto) updates) =>
      super.copyWith((message) => updates(message as PositionedComponentProto))
          as PositionedComponentProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PositionedComponentProto create() => PositionedComponentProto._();
  @$core.override
  PositionedComponentProto createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PositionedComponentProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PositionedComponentProto>(create);
  static PositionedComponentProto? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  IntVectorProto get position => $_getN(1);
  @$pb.TagNumber(2)
  set position(IntVectorProto value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearPosition() => $_clearField(2);
  @$pb.TagNumber(2)
  IntVectorProto ensurePosition() => $_ensure(1);

  @$pb.TagNumber(3)
  FloatVectorProto get scale => $_getN(2);
  @$pb.TagNumber(3)
  set scale(FloatVectorProto value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasScale() => $_has(2);
  @$pb.TagNumber(3)
  void clearScale() => $_clearField(3);
  @$pb.TagNumber(3)
  FloatVectorProto ensureScale() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.double get angle => $_getN(3);
  @$pb.TagNumber(4)
  set angle($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAngle() => $_has(3);
  @$pb.TagNumber(4)
  void clearAngle() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$0.Any> get children => $_getList(4);

  @$pb.TagNumber(6)
  IntVectorProto get size => $_getN(5);
  @$pb.TagNumber(6)
  set size(IntVectorProto value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearSize() => $_clearField(6);
  @$pb.TagNumber(6)
  IntVectorProto ensureSize() => $_ensure(5);
}

class SpatialChunkProto extends $pb.GeneratedMessage {
  factory SpatialChunkProto({
    $core.Iterable<PositionedComponentProto>? components,
  }) {
    final result = create();
    if (components != null) result.components.addAll(components);
    return result;
  }

  SpatialChunkProto._();

  factory SpatialChunkProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SpatialChunkProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SpatialChunkProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'fs.scene_map'),
      createEmptyInstance: create)
    ..pPM<PositionedComponentProto>(1, _omitFieldNames ? '' : 'components',
        subBuilder: PositionedComponentProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpatialChunkProto clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpatialChunkProto copyWith(void Function(SpatialChunkProto) updates) =>
      super.copyWith((message) => updates(message as SpatialChunkProto))
          as SpatialChunkProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SpatialChunkProto create() => SpatialChunkProto._();
  @$core.override
  SpatialChunkProto createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SpatialChunkProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SpatialChunkProto>(create);
  static SpatialChunkProto? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PositionedComponentProto> get components => $_getList(0);
}

class SceneMapProto extends $pb.GeneratedMessage {
  factory SceneMapProto({
    IntVectorProto? worldBounds,
    $core.Iterable<$0.Any>? children,
    $core.int? chunkSize,
    $core.String? chunksDirectory,
  }) {
    final result = create();
    if (worldBounds != null) result.worldBounds = worldBounds;
    if (children != null) result.children.addAll(children);
    if (chunkSize != null) result.chunkSize = chunkSize;
    if (chunksDirectory != null) result.chunksDirectory = chunksDirectory;
    return result;
  }

  SceneMapProto._();

  factory SceneMapProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SceneMapProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SceneMapProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'fs.scene_map'),
      createEmptyInstance: create)
    ..aOM<IntVectorProto>(1, _omitFieldNames ? '' : 'worldBounds',
        subBuilder: IntVectorProto.create)
    ..pPM<$0.Any>(2, _omitFieldNames ? '' : 'children',
        subBuilder: $0.Any.create)
    ..aI(3, _omitFieldNames ? '' : 'chunkSize')
    ..aOS(4, _omitFieldNames ? '' : 'chunksDirectory')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SceneMapProto clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SceneMapProto copyWith(void Function(SceneMapProto) updates) =>
      super.copyWith((message) => updates(message as SceneMapProto))
          as SceneMapProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SceneMapProto create() => SceneMapProto._();
  @$core.override
  SceneMapProto createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SceneMapProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SceneMapProto>(create);
  static SceneMapProto? _defaultInstance;

  @$pb.TagNumber(1)
  IntVectorProto get worldBounds => $_getN(0);
  @$pb.TagNumber(1)
  set worldBounds(IntVectorProto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorldBounds() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorldBounds() => $_clearField(1);
  @$pb.TagNumber(1)
  IntVectorProto ensureWorldBounds() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$0.Any> get children => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get chunkSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set chunkSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChunkSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearChunkSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get chunksDirectory => $_getSZ(3);
  @$pb.TagNumber(4)
  set chunksDirectory($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChunksDirectory() => $_has(3);
  @$pb.TagNumber(4)
  void clearChunksDirectory() => $_clearField(4);
}

class WorldManifestProto extends $pb.GeneratedMessage {
  factory WorldManifestProto({
    IntVectorProto? worldBounds,
    $core.int? chunkSize,
    $core.Iterable<$0.Any>? globalChildren,
    IntVectorProto? initialPlayerPosition,
    $core.bool? shouldSpawnPlayer,
  }) {
    final result = create();
    if (worldBounds != null) result.worldBounds = worldBounds;
    if (chunkSize != null) result.chunkSize = chunkSize;
    if (globalChildren != null) result.globalChildren.addAll(globalChildren);
    if (initialPlayerPosition != null)
      result.initialPlayerPosition = initialPlayerPosition;
    if (shouldSpawnPlayer != null) result.shouldSpawnPlayer = shouldSpawnPlayer;
    return result;
  }

  WorldManifestProto._();

  factory WorldManifestProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorldManifestProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorldManifestProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'fs.scene_map'),
      createEmptyInstance: create)
    ..aOM<IntVectorProto>(1, _omitFieldNames ? '' : 'worldBounds',
        subBuilder: IntVectorProto.create)
    ..aI(2, _omitFieldNames ? '' : 'chunkSize')
    ..pPM<$0.Any>(3, _omitFieldNames ? '' : 'globalChildren',
        subBuilder: $0.Any.create)
    ..aOM<IntVectorProto>(4, _omitFieldNames ? '' : 'initialPlayerPosition',
        subBuilder: IntVectorProto.create)
    ..aOB(5, _omitFieldNames ? '' : 'shouldSpawnPlayer')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorldManifestProto clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorldManifestProto copyWith(void Function(WorldManifestProto) updates) =>
      super.copyWith((message) => updates(message as WorldManifestProto))
          as WorldManifestProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorldManifestProto create() => WorldManifestProto._();
  @$core.override
  WorldManifestProto createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WorldManifestProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorldManifestProto>(create);
  static WorldManifestProto? _defaultInstance;

  @$pb.TagNumber(1)
  IntVectorProto get worldBounds => $_getN(0);
  @$pb.TagNumber(1)
  set worldBounds(IntVectorProto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorldBounds() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorldBounds() => $_clearField(1);
  @$pb.TagNumber(1)
  IntVectorProto ensureWorldBounds() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get chunkSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set chunkSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChunkSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearChunkSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$0.Any> get globalChildren => $_getList(2);

  @$pb.TagNumber(4)
  IntVectorProto get initialPlayerPosition => $_getN(3);
  @$pb.TagNumber(4)
  set initialPlayerPosition(IntVectorProto value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasInitialPlayerPosition() => $_has(3);
  @$pb.TagNumber(4)
  void clearInitialPlayerPosition() => $_clearField(4);
  @$pb.TagNumber(4)
  IntVectorProto ensureInitialPlayerPosition() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get shouldSpawnPlayer => $_getBF(4);
  @$pb.TagNumber(5)
  set shouldSpawnPlayer($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShouldSpawnPlayer() => $_has(4);
  @$pb.TagNumber(5)
  void clearShouldSpawnPlayer() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
