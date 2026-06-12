import 'dart:io';
import 'package:fs_game_data/fs_game_data.dart';
import 'package:path/path.dart' as path;
import 'package:protobuf/protobuf.dart';
import 'proto_gen/fs/scene_map/scene_map.pb.dart';

class SceneMapModule<M extends GeneratedMessage> extends GameDataModule {
  final Map<String, M> _manifests = {};
  final M Function(List<int> bytes) manifestDeserializer;
  final void Function(GeneratedMessage message)? stripSaveStateCallback;

  SceneMapModule({
    required super.dataDirectory,
    required this.manifestDeserializer,
    this.stripSaveStateCallback,
  }) : super(fileName: 'scene_maps');

  Directory get directory => Directory(path.join(dataDirectory.path, fileName));

  Map<String, M> get manifests => _manifests;

  @override
  Future<void> load() async {
    if (!await directory.exists()) {
      await initialize();
      return;
    }

    _manifests.clear();
    final entities = await directory.list().toList();
    for (final entity in entities) {
      if (entity is Directory) {
        final sceneName = path.basename(entity.path);
        final manifestFile = File(
          path.join(entity.path, 'world_manifest.binpb'),
        );
        if (await manifestFile.exists()) {
          final bytes = await manifestFile.readAsBytes();
          _manifests[sceneName] = manifestDeserializer(bytes);
        }
      }
    }
  }

  @override
  Future<void> save() async {
    for (final entry in _manifests.entries) {
      await saveManifest(entry.key, entry.value);
    }
  }

  @override
  Future<void> initialize() async {
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  static String chunksDirectoryForScene(String sceneName) =>
      'scene_maps/$sceneName/chunks';

  Future<void> saveManifest(
    String sceneName,
    M manifest, {
    bool stripSaveState = true,
  }) async {
    if (stripSaveState && stripSaveStateCallback != null) {
      stripSaveStateCallback!(manifest);
    }
    final sceneDir = Directory(path.join(directory.path, sceneName));
    if (!await sceneDir.exists()) {
      await sceneDir.create(recursive: true);
    }

    final chunksDir = Directory(path.join(sceneDir.path, 'chunks'));
    if (!await chunksDir.exists()) {
      await chunksDir.create(recursive: true);
    }

    final manifestFile = File(path.join(sceneDir.path, 'world_manifest.binpb'));
    await manifestFile.writeAsBytes(manifest.writeToBuffer());
    _manifests[sceneName] = manifest;
  }

  Future<void> deleteSceneMap(String sceneName) async {
    final sceneDir = Directory(path.join(directory.path, sceneName));
    if (await sceneDir.exists()) {
      await sceneDir.delete(recursive: true);
    }
    _manifests.remove(sceneName);
  }
}

/// A concrete SceneMapModule using the built-in fs_scene_map protos.
class GenericSceneMapModule extends SceneMapModule<WorldManifestProto> {
  GenericSceneMapModule({
    required super.dataDirectory,
    super.stripSaveStateCallback,
  }) : super(
          manifestDeserializer: (bytes) => WorldManifestProto.fromBuffer(bytes),
        );
}
