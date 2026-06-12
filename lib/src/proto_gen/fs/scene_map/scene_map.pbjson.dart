// This is a generated file - do not edit.
//
// Generated from fs/scene_map/scene_map.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use intVectorProtoDescriptor instead')
const IntVectorProto$json = {
  '1': 'IntVectorProto',
  '2': [
    {'1': 'values', '3': 1, '4': 3, '5': 5, '10': 'values'},
  ],
};

/// Descriptor for `IntVectorProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List intVectorProtoDescriptor = $convert
    .base64Decode('Cg5JbnRWZWN0b3JQcm90bxIWCgZ2YWx1ZXMYASADKAVSBnZhbHVlcw==');

@$core.Deprecated('Use floatVectorProtoDescriptor instead')
const FloatVectorProto$json = {
  '1': 'FloatVectorProto',
  '2': [
    {'1': 'values', '3': 1, '4': 3, '5': 2, '10': 'values'},
  ],
};

/// Descriptor for `FloatVectorProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List floatVectorProtoDescriptor = $convert
    .base64Decode('ChBGbG9hdFZlY3RvclByb3RvEhYKBnZhbHVlcxgBIAMoAlIGdmFsdWVz');

@$core.Deprecated('Use positionedComponentProtoDescriptor instead')
const PositionedComponentProto$json = {
  '1': 'PositionedComponentProto',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {
      '1': 'position',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.fs.scene_map.IntVectorProto',
      '10': 'position'
    },
    {
      '1': 'scale',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.fs.scene_map.FloatVectorProto',
      '10': 'scale'
    },
    {'1': 'angle', '3': 4, '4': 1, '5': 2, '10': 'angle'},
    {
      '1': 'children',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'children'
    },
    {
      '1': 'size',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.fs.scene_map.IntVectorProto',
      '10': 'size'
    },
  ],
};

/// Descriptor for `PositionedComponentProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List positionedComponentProtoDescriptor = $convert.base64Decode(
    'ChhQb3NpdGlvbmVkQ29tcG9uZW50UHJvdG8SDgoCaWQYASABKANSAmlkEjgKCHBvc2l0aW9uGA'
    'IgASgLMhwuZnMuc2NlbmVfbWFwLkludFZlY3RvclByb3RvUghwb3NpdGlvbhI0CgVzY2FsZRgD'
    'IAEoCzIeLmZzLnNjZW5lX21hcC5GbG9hdFZlY3RvclByb3RvUgVzY2FsZRIUCgVhbmdsZRgEIA'
    'EoAlIFYW5nbGUSMAoIY2hpbGRyZW4YBSADKAsyFC5nb29nbGUucHJvdG9idWYuQW55UghjaGls'
    'ZHJlbhIwCgRzaXplGAYgASgLMhwuZnMuc2NlbmVfbWFwLkludFZlY3RvclByb3RvUgRzaXpl');

@$core.Deprecated('Use spatialChunkProtoDescriptor instead')
const SpatialChunkProto$json = {
  '1': 'SpatialChunkProto',
  '2': [
    {
      '1': 'components',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.fs.scene_map.PositionedComponentProto',
      '10': 'components'
    },
  ],
};

/// Descriptor for `SpatialChunkProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List spatialChunkProtoDescriptor = $convert.base64Decode(
    'ChFTcGF0aWFsQ2h1bmtQcm90bxJGCgpjb21wb25lbnRzGAEgAygLMiYuZnMuc2NlbmVfbWFwLl'
    'Bvc2l0aW9uZWRDb21wb25lbnRQcm90b1IKY29tcG9uZW50cw==');

@$core.Deprecated('Use sceneMapProtoDescriptor instead')
const SceneMapProto$json = {
  '1': 'SceneMapProto',
  '2': [
    {
      '1': 'world_bounds',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.fs.scene_map.IntVectorProto',
      '10': 'worldBounds'
    },
    {
      '1': 'children',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'children'
    },
    {'1': 'chunk_size', '3': 3, '4': 1, '5': 5, '10': 'chunkSize'},
    {'1': 'chunks_directory', '3': 4, '4': 1, '5': 9, '10': 'chunksDirectory'},
  ],
};

/// Descriptor for `SceneMapProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sceneMapProtoDescriptor = $convert.base64Decode(
    'Cg1TY2VuZU1hcFByb3RvEj8KDHdvcmxkX2JvdW5kcxgBIAEoCzIcLmZzLnNjZW5lX21hcC5Jbn'
    'RWZWN0b3JQcm90b1ILd29ybGRCb3VuZHMSMAoIY2hpbGRyZW4YAiADKAsyFC5nb29nbGUucHJv'
    'dG9idWYuQW55UghjaGlsZHJlbhIdCgpjaHVua19zaXplGAMgASgFUgljaHVua1NpemUSKQoQY2'
    'h1bmtzX2RpcmVjdG9yeRgEIAEoCVIPY2h1bmtzRGlyZWN0b3J5');

@$core.Deprecated('Use worldManifestProtoDescriptor instead')
const WorldManifestProto$json = {
  '1': 'WorldManifestProto',
  '2': [
    {
      '1': 'world_bounds',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.fs.scene_map.IntVectorProto',
      '10': 'worldBounds'
    },
    {'1': 'chunk_size', '3': 2, '4': 1, '5': 5, '10': 'chunkSize'},
    {
      '1': 'global_children',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'globalChildren'
    },
    {
      '1': 'initial_player_position',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.fs.scene_map.IntVectorProto',
      '10': 'initialPlayerPosition'
    },
    {
      '1': 'should_spawn_player',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'shouldSpawnPlayer'
    },
  ],
};

/// Descriptor for `WorldManifestProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List worldManifestProtoDescriptor = $convert.base64Decode(
    'ChJXb3JsZE1hbmlmZXN0UHJvdG8SPwoMd29ybGRfYm91bmRzGAEgASgLMhwuZnMuc2NlbmVfbW'
    'FwLkludFZlY3RvclByb3RvUgt3b3JsZEJvdW5kcxIdCgpjaHVua19zaXplGAIgASgFUgljaHVu'
    'a1NpemUSPQoPZ2xvYmFsX2NoaWxkcmVuGAMgAygLMhQuZ29vZ2xlLnByb3RvYnVmLkFueVIOZ2'
    'xvYmFsQ2hpbGRyZW4SVAoXaW5pdGlhbF9wbGF5ZXJfcG9zaXRpb24YBCABKAsyHC5mcy5zY2Vu'
    'ZV9tYXAuSW50VmVjdG9yUHJvdG9SFWluaXRpYWxQbGF5ZXJQb3NpdGlvbhIuChNzaG91bGRfc3'
    'Bhd25fcGxheWVyGAUgASgIUhFzaG91bGRTcGF3blBsYXllcg==');
