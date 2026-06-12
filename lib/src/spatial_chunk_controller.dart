import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:protobuf/protobuf.dart';
import 'package:protobuf_serializable_components/protobuf_serializable_components.dart';
import 'spatial_chunk_manager.dart';
import 'spatial_chunk_component.dart';

mixin HasGridChunks on Component {
  SpatialChunkController? get spatialChunkController;
}

extension WorldGridChunksExtension on World {
  SpatialChunkController? get spatialChunkController {
    final direct = firstChild<SpatialChunkController>();
    if (direct != null) return direct;
    final hasGridChunks = descendants().whereType<HasGridChunks>().firstOrNull;
    return hasGridChunks?.spatialChunkController;
  }
}

class SpatialChunkController<I extends GeneratedMessage, P extends GeneratedMessage> extends Component
    with HasGameReference<FlameGame> {
  final SpatialChunkManager<I, P> chunkManager;
  final SerializableComponentRegistry? registry;
  final double loadBuffer;
  final Component Function(P proto, (int, int) criteria) chunkBuilder;

  final Map<(int, int), Component> _loadedChunks = {};
  final Set<(int, int)> _loadingChunks = {};

  bool isEditMode = false;
  final bool Function()? checkEditorMode;

  bool get _effectiveIsEditMode {
    if (isEditMode) return true;
    return checkEditorMode?.call() ?? false;
  }

  SpatialChunkController({
    required this.chunkManager,
    required this.chunkBuilder,
    this.registry,
    this.isEditMode = false,
    this.checkEditorMode,
    this.loadBuffer = 0,
  });

  void _logTrace(String msg) {
    try {
      (game as dynamic).logger.t(msg);
    } catch (_) {
      // Fallback if logger.t is not defined on game
    }
  }

  void _logError(String msg) {
    try {
      (game as dynamic).logger.e(msg);
    } catch (_) {
      print('ERROR: $msg');
    }
  }

  @override
  void onMount() {
    super.onMount();
    // Sync with existing chunks if any
    try {
      final p = parent;
      if (p != null) {
        for (final child in p.children) {
          if (child is HasChunkCriteria) {
            final criteria = (child as HasChunkCriteria).criteria;
            if (criteria != null) {
              _loadedChunks[criteria] = child;
            }
          }
        }
      }
    } catch (_) {
      // Fail safely if game or camera is not ready
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateChunks();
  }

  void _updateChunks() {
    if (!isMounted) return;
    final p = parent;
    if (p == null) return;

    try {
      final camera = game.camera;
      final visibleRect = camera.visibleWorldRect;
      final paddedRect = visibleRect.inflate(loadBuffer);

      double left = paddedRect.left;
      double top = paddedRect.top;
      double right = paddedRect.right;
      double bottom = paddedRect.bottom;

      if (p is PositionComponent) {
        final corners = [
          p.absoluteToLocal(Vector2(paddedRect.left, paddedRect.top)),
          p.absoluteToLocal(Vector2(paddedRect.right, paddedRect.top)),
          p.absoluteToLocal(Vector2(paddedRect.left, paddedRect.bottom)),
          p.absoluteToLocal(Vector2(paddedRect.right, paddedRect.bottom)),
        ];
        left = corners.map((c) => c.x).reduce(min);
        top = corners.map((c) => c.y).reduce(min);
        right = corners.map((c) => c.x).reduce(max);
        bottom = corners.map((c) => c.y).reduce(max);
      }

      final start = chunkManager.getCriteriaFromPosition(left, top);
      final end = chunkManager.getCriteriaFromPosition(right, bottom);

      // Safety cap: max range from center to prevent loading thousands of chunks
      const maxHalfRange = 250; // Resulting in max 501x501 chunks
      final center = chunkManager.getCriteriaFromPosition(
        (left + right) / 2,
        (top + bottom) / 2,
      );

      final finalStart = (
        start.$1.clamp(center.$1 - maxHalfRange, center.$1 + maxHalfRange),
        start.$2.clamp(center.$2 - maxHalfRange, center.$2 + maxHalfRange),
      );
      final finalEnd = (
        end.$1.clamp(center.$1 - maxHalfRange, center.$1 + maxHalfRange),
        end.$2.clamp(center.$2 - maxHalfRange, center.$2 + maxHalfRange),
      );

      _ensureInRect(finalStart, finalEnd);
    } catch (_) {
      // Fail safely if game or camera is not ready
    }
  }

  void _ensureInRect((int, int) start, (int, int) end) {
    for (int x = start.$1; x <= end.$1; x++) {
      for (int y = start.$2; y <= end.$2; y++) {
        final criteria = (x, y);
        if (!_loadedChunks.containsKey(criteria) &&
            !_loadingChunks.contains(criteria)) {
          _loadChunk(criteria);
        }
      }
    }

    // Unload far away chunks (if not in edit mode)
    if (!_effectiveIsEditMode) {
      _unloadFarChunks(start, end, 2);
    }
  }

  void _unloadFarChunks((int, int) start, (int, int) end, int buffer) {
    final keysToRemove = <(int, int)>[];
    _loadedChunks.forEach((criteria, chunk) {
      if (criteria.$1 < start.$1 - buffer ||
          criteria.$1 > end.$1 + buffer ||
          criteria.$2 < start.$2 - buffer ||
          criteria.$2 > end.$2 + buffer) {
        keysToRemove.add(criteria);
      }
    });

    for (final key in keysToRemove) {
      final chunk = _loadedChunks.remove(key);
      chunk?.removeFromParent();
    }
  }

  Future<void> _loadChunk((int, int) criteria) async {
    _loadingChunks.add(criteria);
    try {
      _logTrace('SpatialChunkController: Loading chunk $criteria');
      final proto = await chunkManager.getOrLoadChunk(criteria);
      if (isMounted && parent != null) {
        final chunkComponent = chunkBuilder(proto, criteria);
        _loadedChunks[criteria] = chunkComponent;
        parent?.add(chunkComponent);
        _logTrace('SpatialChunkController: Added chunk $criteria to parent');
      }
    } catch (e) {
      _logError('SpatialChunkController: Failed to load chunk $criteria: $e');
    } finally {
      _loadingChunks.remove(criteria);
    }
  }

  /// Checks if a component should be moved to a different chunk based on its position.
  /// If it needs moving, it will be re-parented in the Flame tree and the data-level
  /// move will be handled by the [chunkManager].
  Future<void> reparentComponent(Component component) async {
    if (component is! PositionComponent || component is! ProtoSerializable) {
      return;
    }

    final currentChunk = component.parent;
    final oldCriteria = currentChunk is HasChunkCriteria
        ? (currentChunk as HasChunkCriteria).criteria
        : null;

    // Skip nested components (they should stay with their parent, not be root-level in chunks)
    // We check if parent is a chunk by verifying if it is one of the loaded chunks.
    final isParentAChunk = currentChunk != null && _loadedChunks.containsValue(currentChunk);
    if (currentChunk != parent && !isParentAChunk) {
      return;
    }

    final newCriteria = chunkManager.getCriteriaFromPosition(
      component.position.x,
      component.position.y,
    );

    // Handle data-level move
    final proto = (component as ProtoSerializable).serialize();

    if (oldCriteria == newCriteria) {
      if (oldCriteria != null) {
        chunkManager.markDirty(oldCriteria);
      }
      return;
    }

    // Handle Flame-level move first
    // If the new chunk is loaded, add it there.
    var targetChunk = _loadedChunks[newCriteria];
    if (targetChunk == null && _effectiveIsEditMode) {
      await _loadChunk(newCriteria);
      targetChunk = _loadedChunks[newCriteria];
    }

    if (targetChunk != null) {
      targetChunk.add(component);
    }

    // Handle data-level move last
    if (proto is I) {
      if (oldCriteria != null) {
        await chunkManager.moveItem(proto, oldCriteria);
      } else {
        await chunkManager.writeItem(proto);
      }
    }
  }

  void markDirty(Component component) {
    if (component is! PositionComponent) return;
    final criteria = chunkManager.getCriteriaFromPosition(
      component.position.x,
      component.position.y,
    );
    chunkManager.markDirty(criteria);
  }
}


