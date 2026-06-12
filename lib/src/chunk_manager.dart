abstract class ChunkManager<I, P, K> {
  final Map<K, P> _chunks = {};
  final Set<K> _dirtyChunks = {};
  final bool isEditorMode;

  /// Optional loader function to fetch a chunk from external storage.
  final Future<P?> Function(K criteria)? loader;

  /// Optional saver function to persist a chunk to external storage.
  final Future<void> Function(K criteria, P proto)? saver;

  ChunkManager({this.loader, this.saver, this.isEditorMode = false});

  /// Matches an item to a chunk's identifying criteria.
  K getChunkCriteria(I item);

  /// Returns the filename for a given chunk criteria.
  String getFileName(K criteria);

  /// Creates a new empty proto for a chunk.
  P createChunkProto();

  /// Adds an item to a chunk proto.
  void addItemToChunk(P proto, I item);

  /// Parses a chunk's identifying criteria from its filename.
  K? parseCriteriaFromFileName(String fileName);

  /// Manually populates a chunk in the cache.
  void preloadChunk(K criteria, P proto) {
    _chunks[criteria] = proto;
  }

  /// Loads a chunk proto for a given criteria.
  /// Defaults to using the [loader] if provided.
  Future<P?> loadChunk(K criteria) {
    return loader?.call(criteria) ?? Future.value(null);
  }

  /// Gets the set of chunk criteria that have unsaved changes.
  Set<K> get dirtyChunks => _dirtyChunks;

  /// Clears the set of dirty chunks.
  void clearDirtyChunks() => _dirtyChunks.clear();

  /// Marks a specific chunk as dirty.
  void markDirty(K criteria) => _dirtyChunks.add(criteria);

  /// Gets a chunk from the internal cache, or loads it if not present.
  /// If the chunk doesn't exist on disk, a new empty chunk is created.
  Future<P> getOrLoadChunk(K criteria) async {
    if (_chunks.containsKey(criteria)) {
      return _chunks[criteria]!;
    }

    final proto = await loadChunk(criteria) ?? createChunkProto();
    _chunks[criteria] = proto;
    return proto;
  }

  /// Writes an item to the appropriate chunk and marks it dirty.
  Future<void> writeItem(I item) async {
    final criteria = getChunkCriteria(item);
    final proto = await getOrLoadChunk(criteria);
    addItemToChunk(proto, item);
    markDirty(criteria);
  }

  /// Deletes an item from the appropriate chunk and marks it dirty.
  Future<void> deleteItem(K criteria, dynamic id);

  /// Saves all chunks that have unsaved changes.
  /// Defaults to using the [saver] if provided.
  Future<void> saveDirtyChunks([
    Future<void> Function(K criteria, P proto)? customSaver,
  ]) async {
    final activeSaver = customSaver ?? saver;
    if (activeSaver == null) return;

    for (final criteria in _dirtyChunks) {
      final proto = _chunks[criteria];
      if (proto != null) {
        await activeSaver(criteria, proto);
      }
    }
    clearDirtyChunks();
  }

  /// Helper to split items into chunks.
  Map<String, P> split(Iterable<I> items) {
    final Map<K, P> chunks = {};
    for (final item in items) {
      final criteria = getChunkCriteria(item);
      final proto = chunks.putIfAbsent(criteria, () => createChunkProto());
      addItemToChunk(proto, item);
    }
    return chunks.map(
      (criteria, proto) => MapEntry(getFileName(criteria), proto),
    );
  }
}
