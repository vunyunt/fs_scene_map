import 'package:fixnum/fixnum.dart';
import 'package:path/path.dart' as path;
import 'package:protobuf/protobuf.dart';
import 'proto_gen/fs/scene_map/scene_map.pb.dart';
import 'vector_proto_extensions.dart';
import 'chunk_manager.dart';

class SpatialChunkManager<I extends GeneratedMessage, P extends GeneratedMessage>
    extends ChunkManager<I, P, (int, int)> {
  final String basePath;
  final int gridWidth;
  final int gridHeight;

  final (double, double) Function(I item) getPosition;
  final dynamic Function(I item) getId;
  final void Function(P proto, I item) addItem;
  final void Function(P proto, dynamic id) removeItem;
  final P Function() createProto;

  SpatialChunkManager({
    required this.basePath,
    required this.getPosition,
    required this.getId,
    required this.addItem,
    required this.removeItem,
    required this.createProto,
    this.gridWidth = 100,
    this.gridHeight = 100,
    super.loader,
    super.saver,
    super.isEditorMode,
  });



  @override
  (int, int) getChunkCriteria(I item) {
    final pos = getPosition(item);
    return getCriteriaFromPosition(pos.$1, pos.$2);
  }

  /// Handles an item moving from one chunk to another (potential same chunk).
  /// This updates the internal proto collections and dirty states.
  Future<void> moveItem(I item, (int, int) oldCriteria) async {
    final newCriteria = getChunkCriteria(item);
    if (oldCriteria == newCriteria) {
      markDirty(newCriteria);
      return;
    }

    // Remove from old chunk.
    await deleteItem(oldCriteria, getId(item));

    // Add to new chunk.
    await writeItem(item);
  }

  @override
  Future<void> deleteItem((int, int) criteria, dynamic id) async {
    final proto = await getOrLoadChunk(criteria);
    removeItem(proto, id);
    // Since removeItem is side-effecting on the proto, we mark it dirty.
    markDirty(criteria);
  }

  /// Calculates the chunk criteria (grid coordinates) for a given world position.
  (int, int) getCriteriaFromPosition(double x, double y) {
    // Use floor division to ensure consistent grid cells across negative coordinates
    return ((x / gridWidth).floor(), (y / gridHeight).floor());
  }

  /// Returns the world bounds (left, top, right, bottom) for a given chunk criteria.
  (double, double, double, double) getRectFromCriteria((int, int) criteria) {
    final left = criteria.$1 * gridWidth.toDouble();
    final top = criteria.$2 * gridHeight.toDouble();
    return (left, top, left + gridWidth, top + gridHeight);
  }

  @override
  String getFileName((int, int) criteria) {
    final fileName = 'spatial_chunk_${criteria.$1}_${criteria.$2}.binpb';
    if (basePath.isEmpty) return fileName;
    return path.join(basePath, fileName);
  }

  @override
  P createChunkProto() => createProto();

  @override
  void addItemToChunk(P proto, I item) {
    addItem(proto, item);
  }

  @override
  (int, int)? parseCriteriaFromFileName(String fileName) {
    final baseName = path.basename(fileName);
    if (!baseName.startsWith('spatial_chunk_') ||
        !baseName.endsWith('.binpb')) {
      return null;
    }
    final parts = baseName.substring(14, baseName.length - 6).split('_');
    if (parts.length != 2) return null;
    final x = int.tryParse(parts[0]);
    final y = int.tryParse(parts[1]);
    if (x != null && y != null) return (x, y);
    return null;
  }
}

/// A concrete SpatialChunkManager that uses the built-in fs_scene_map protos.
class GenericSpatialChunkManager extends SpatialChunkManager<PositionedComponentProto, SpatialChunkProto> {
  GenericSpatialChunkManager({
    required super.basePath,
    super.gridWidth = 100,
    super.gridHeight = 100,
    super.loader,
    super.saver,
    super.isEditorMode,
  }) : super(
          getPosition: (item) => (
            item.position.xOrZero.toDouble(),
            item.position.yOrZero.toDouble(),
          ),
          getId: (item) => item.id,
          addItem: (proto, item) {
            if (item.id != Int64.ZERO) {
              proto.components.removeWhere((c) => c.id == item.id);
            }
            proto.components.add(item);
          },
          removeItem: (proto, id) {
            proto.components.removeWhere((c) => c.id == id);
          },
          createProto: () => SpatialChunkProto(),
        );
}
